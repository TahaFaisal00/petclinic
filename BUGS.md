# Known Bugs — PetClinic

Defects found while building the database validation suite against
[spring-petclinic-rest](https://github.com/spring-petclinic/spring-petclinic-rest)
backed by MySQL 8.4. Each entry links to a full GitHub issue with steps, evidence,
and the test that documents it.

Bugs are classified by the **surface** they were found through, their **severity**
by real impact, and their reproducibility — the same conventions used in the
[DemoQA](https://github.com/TahaFaisal00/demoqa) and
[AutomationExercise](https://github.com/TahaFaisal00/automationexercise) repos.

Two things shape this list. First, **scope**: this repo documents findings the
database can prove. API contract and documentation defects are already covered at
length in the other two repos and are deliberately excluded here — see
[Coverage decisions](#coverage-decisions). Second, **the application**:
spring-petclinic-rest is a maintained reference implementation, not a deliberately
broken demo site. It yields one real defect, not twenty. The value of this suite is
the method rather than the count — every assertion is made against the database,
never against the response that claimed the write happened.

---

## API

| # | Title | Type | Severity | Notes |
|---|-------|------|----------|-------|
| [#1](https://github.com/TahaFaisal00/petclinic/issues/1) | `DELETE /api/owners/{id}` fails for any owner that has pets — declared cascade does not execute | Functional (API) | Major | Verified at both the schema and the application layer; asserted as current behavior |

---

## The finding

### Declared cascade does not execute on the owner→pet path — #1

The application declares delete-cascade on the owner→pet relationship. It does not
perform it. `DELETE /api/owners/{id}` on an owner that has a pet is rejected with a
data constraint violation, and both the owner and its pet remain in the database.

What makes this a precise finding rather than "delete is broken" is that the rule
was located at both layers it could live in:

**The database does not implement the cascade.** Neither foreign key declares
`ON DELETE CASCADE`, so both default to `RESTRICT`:

```text
SHOW CREATE TABLE pets;
"..CONSTRAINT `pets_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `owners` (`id`).."

SHOW CREATE TABLE visits;
"..CONSTRAINT `visits_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`).."
```

**The application owns it, and declares it:**

```text
@OneToMany(cascade = CascadeType.ALL, mappedBy = "owner", fetch = FetchType.EAGER)
private Set<Pet> pets;
```

**The contrast is the evidence.** One level down, on the pet→visit path, the same
declaration under the *identical* database rule works correctly: `DELETE /api/pets/{id}`
on a pet that has a visit returns 204 and removes the visit, leaving no orphans.
Same parent-child shape, same `RESTRICT` foreign key, opposite outcomes. The
database cannot account for the difference, which places the inconsistency in the
application with no ambiguity.

The consequence is not cosmetic. Most owners have pets, and an owner is the reason
a pet record exists at all — so owner deletion is effectively non-functional against
realistic data. A client can work around it by deleting each pet individually first,
but that forces the client to reimplement a cascade the application already declares,
across N+1 unsynchronized requests with no transaction around them.

---

## Verified positives

Not every test that hunts for a defect finds one. These are hypotheses the
application survived — recorded because a tested-and-cleared result is a finding,
not a blank.

### The API resists SQL injection through the query filter — CWE-89
`GET /api/owners?lastName=' OR '1'='1` is treated as literal string data. The
request returns 404 with an empty body, does **not** return 500, and does not leak
data. A normal no-match query was confirmed to also return 404, so 404 is the
correct baseline here and not a coincidence — the injection string is simply a last
name nobody has. Parameterisation is holding.

### Non-ASCII data survives the round trip — utf8mb4
An owner created with the Arabic first name `أحمد` returns 201, and the
`first_name` column read straight back from MySQL matches the value exactly.
Character-set correctness is verified at the storage layer, not inferred from the
API echoing the request back.

### Fixture data has valid referential integrity
Every foreign key in the schema was checked for orphans — `pets→owners`,
`pets→types`, `visits→pets`, and the `vet_specialties` junction against **both**
`vets` and `specialties`. No orphans exist. The seed data also matches its expected
baseline on volume (10 owners, 13 pets, 6 vets) and on content (4 owners in Madison,
2 pets named Lucky), and carries no duplicate values in fields that must be unique
(owner telephones, specialty names).

---

## Coverage decisions

Where a check was not performed, or a defect was not filed here, the reasoning is
recorded rather than left as a silent gap.

### The composite unique constraint is unreachable through the API
`vet_specialties` carries `UNIQUE KEY (vet_id, specialty_id)`, but no endpoint
assigns multiple specialties to a vet — a specialty can only be set at creation or
replaced. The duplicate that would violate the constraint cannot be constructed
through the API, so it is not covered by the suite. It **was** verified manually in
DBeaver: the duplicate insert is rejected by the database. A DB-only test is a
viable future addition.

### Swagger contract defects are out of scope for this repo
`PUT /api/owners/{id}` documents a 200 response and returns 204. It is a real
defect, and it is not filed here. Swagger unreliability is documented extensively
across the DemoQA and AutomationExercise repos and adding another instance would
dilute this repo's subject without adding a new class of finding.

### The 404 status on the failed delete is noted, not filed
The rejected delete in #1 returns HTTP 404 for a resource that demonstrably still
exists; 409 Conflict would be correct. That is an API contract defect with no
database component to it, so it belongs to the territory the other two repos cover.
It is recorded inside #1's notes rather than filed as its own issue.

---

## Test traceability

Every finding above names the test that documents it. Tests follow the
"document-the-bug" pattern used across all three repos: they assert the *actual*
behavior so the suite stays green while the defect exists, and flip red if the
application is ever fixed.

| Finding | Test | File |
|---------|------|------|
| #1 — cascade does not execute | `Delete Owner With Pet Should Be Rejected And Not Cascade` | `integrity.robot` |
| #1 — the working contrast | `Delete Pet With Visit Should Cascade Remove Visit In Database` | `integrity.robot` |
| SQL injection resistance | `Get Owners List With SQL Injection Should Not Leak Data` | `integrity.robot` |
| utf8mb4 round trip | `Create Owner With Non Latin Name Should Persist Correctly In Database` | `integrity.robot` |
| Referential integrity | `Fixture Data Should Have Valid Referential Integrity` | `data_lifecycle.robot` |
| Seed baseline | `Fixture Data Should Match Expected Baseline` | `data_lifecycle.robot` |
| Unique-field duplicates | `Fixture Data Should Have No Duplicated Unique Fields` | `data_lifecycle.robot` |
| Composite unique constraint | *not covered — unreachable via API, verified manually* | — |
