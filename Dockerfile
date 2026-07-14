FROM python:3.12-slim

WORKDIR /tests

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Default DB host = the compose service name, for running inside the Docker network.
# Override to 127.0.0.1 when running against a host-published port.
ENV DB_HOST=mysql

CMD ["robot", "--outputdir", "log", "Tests"]