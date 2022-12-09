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
- Version Control: _Git and GitHub_.

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

**Run the production environment locally:**
- Get the environment variables from the infrastructure:
  ```shell
  python scripts/get_infra_output.py --compose=infrastructure/.docker-compose.yml --module=azure
  ```
- Update the `backend/.env/.env.production` file.
- Run Docker Compose:
  ```shell
  docker compose -f backend/.docker-compose/production.yml up -d --build
  ```

---

### Infrastructure:

**Setup Terraform Backend:**
- Create a storage on Azure Blob Storage.
  ```shell

  export resource_group=terraform-resource-group;
  export location=eastus;
  export storage_account=myterraformbackend;
  export container=terraform-backend;

  az group create --name $resource_group --location $location;
  
  az storage account create \
  --name $storage_account \
  --resource-group $resource_group \
  --location $location \
  --sku Standard_RAGRS \
  --kind StorageV2;
  
  az storage container create \
    --account-name $storage_account \
    --name $container \
    --auth-mode login;
  
  ```
- Authenticating to Azure Provider [by following this link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret).
- Create a file and name it to `.backend.hcl` under `infrastructure` folder.
- Copy the content of file `.backend.hcl.sample` inside it and fill the values.

**Setup Secrets:**
- Create a file with the name `.secrets.auto.tfvars` under `infrastructure` folder.
- Copy the contents of file `.secrets.auto.tfvars.sample` inside it and fill the values.

**Setup SSH:**
- Generate an SSH Key.
- Create a folder with the name `.ssh` under `infrastructure` folder.
- Copy `id_rsa.pub` and `id_rsa` file to `infrastructure/.ssh`.

**Run Terraform Commands:**

- terraform init
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform init -backend-config=.backend.hcl
  ```

-
- terraform plan all
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform plan
  ```
- terraform plan azure
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform plan -target="module.azure"
  ```
- terraform plan github
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform plan -target="module.github" --auto-approve
  ```


-
- terraform apply all
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform apply --auto-approve
  ```
- terraform apply azure
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform apply -target="module.azure" --auto-approve
  ```
- terraform apply github
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform apply -target="module.github" --auto-approve
  ```


- 
- terraform destroy all
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform destroy --auto-approve
  ```
- terraform destroy azure
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform destroy -target="module.azure" --auto-approve
  ```
- terraform destroy github
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform destroy -target="module.github" --auto-approve
  ```

- 
- terraform output azure
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform output azure
  ```

---

### Deployment:

#### Deploy Manually:
- Create the Azure resources by following the infrastructure section.
- Export values and change them according to your infrastructure:
  ```shell
  export ACR_URL=<YOUR_ACR_URL>;
  export ACR_USERNAME=<YOUR_ACR_USERNAME>;
  export ACR_PASSWORD=<YOUR_ACR_PASSWORD>;
  
  export IMG_NAME=<your_image_name>;
  export IMG_TAG=<your_image_tag>;
  
  export FINAL_IMAGE=$ACR_USERNAME.azurecr.io/$IMG_NAME:$IMG_TAG;
  
  export ENVIRONMENT=production;
  
  export MACHINE_IP=<YOUR_MACHINE_IP>;
  export MACHINE_USER=<YOUR_MACHINE_USER>;
  ```


- Login to Azure Container Registry:
  ```shell
  docker login $ACR_URL -u $ACR_USERNAME -p $ACR_PASSWORD
  ```
- Build a Docker image:
  ```shell
  docker build -t $FINAL_IMAGE -f backend/Dockerfile backend --build-arg ENVIRONMENT=$ENVIRONMENT
  ```
- Push the Docker image to Azure Container Registry:
  ```shell
  docker push $FINAL_IMAGE
  ```


- Copy the env file and the run script to the server:
  ```shell
  rsync backend/.env/.env.$ENVIRONMENT scripts/run_backend.py $MACHINE_USER@$MACHINE_IP:/home/$MACHINE_USER
  ```


- Login to Azure Container Registry on the server:
  ```shell
  ssh $MACHINE_USER@$MACHINE_IP "docker login $ACR_URL -u $ACR_USERNAME -p $ACR_PASSWORD"
  ```
- Run the script on the server:
  ```shell
  ssh $MACHINE_USER@$MACHINE_IP "python3 run_backend.py --env=.env.$ENVIRONMENT --image=$FINAL_IMAGE"
  ```

---
