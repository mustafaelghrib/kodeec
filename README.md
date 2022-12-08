## Kodeec
A full production backend API built with these tech stacks:

- REST API: _Flask and Flask-RESTFul_.
- Database: _PostgresSQL_.
- Unit Testing: _Pytest_.
- Packaging Management: _Poetry_.
- Containerization: _Docker and Docker Compose_.
- Cloud Provider: _Microsoft Azure:_
  - _Azure VNet (Virtual Network)._
  - _Azure Virtual Machine._
  - _Azure Database for PostgreSQL._
  - _Azure Blob Storage._
  - _Azure Container Registry (ACR)._
- Infrastructure as Code: _Terraform_.
- CI/CD: _GitHub Actions_.

---

### Backend:

**Set the environment variables:**
- Copy `backend/.env.sample/` folder and rename it to `backend/.env/`.

**Run the base environment locally:**
- Update the `backend/.env/.env.base` file.
- Run Docker Compose:
  ```shell
  docker compose -f backend/.docker-compose/base.yml up -d --build
  ```
- Run Pytest:
  ```shell
  docker exec -it kodeec_base_flask /bin/bash -c "/opt/venv/bin/pytest"
  ```

---

### Infrastructure:

**Setup Terraform Backend:**
- Create a storage on Azure Blob Storage.
- Create a file and name it to `.backend.hcl` under `infrastructure` folder.
- Copy the content of file `.backend.hcl.sample` inside it and fill the values.

**Run Terraform Commands:**

- terraform init
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform init -backend-config=.backend.hcl
  ```
- terraform plan
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform plan
  ```
- terraform apply
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform apply --auto-approve
  ```
- terraform destroy
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform destroy --auto-approve
  ```

---

