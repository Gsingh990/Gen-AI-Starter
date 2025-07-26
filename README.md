# GenAI Starter Stack

## Executive Summary

This GenAI Starter Stack provides a comprehensive, **enterprise-grade** foundation for building and deploying Retrieval-Augmented Generation (RAG) chatbots on Microsoft Azure. It has been enhanced with a user-friendly web interface and critical production features, including robust security, auto-scaling, monitoring, and automated testing. It leverages a powerful combination of Azure-native services and popular open-source technologies, orchestrated through enterprise-grade Infrastructure-as-Code (IaC) and a modular application architecture. This stack significantly accelerates the development and deployment of custom GenAI solutions, reducing time-to-value by providing a secure, scalable, and cost-effective blueprint.

## Project Overview

The primary purpose of this GenAI Starter Stack is to empower organizations to rapidly develop and deploy intelligent, enterprise-ready applications capable of interacting with and providing answers based on their proprietary data. The included RAG chatbot now features a full user interface and has been fortified for production workloads.

**Key Capabilities of the Stack:**

*   **Interactive Chat UI:** A clean, responsive, and user-friendly web interface for interacting with the chatbot.
*   **Enterprise-Grade Security:** Secure management of sensitive credentials (like API keys) using Azure Key Vault, integrated with AKS via the Secrets Store CSI Driver.
*   **High Availability & Auto-Scaling:** Ensures the application is resilient and can handle variable loads with Kubernetes liveness/readiness probes and a Horizontal Pod Autoscaler (HPA).
*   **Monitoring & Observability:** Exposes key application metrics via a `/metrics` endpoint for Prometheus and uses structured logging for easier analysis and debugging.
*   **Improved Code Quality:** Includes a suite of unit tests for the core application logic, ensuring reliability and maintainability.

This project provides the following core components:

*   **Infrastructure as Code (IaC):** A complete set of modular Terraform configurations to provision and manage all necessary Azure resources, ensuring repeatable, consistent, and version-controlled infrastructure deployments.
*   **RAG Chatbot Application:** A functional, containerized Python FastAPI application demonstrating the RAG pattern, integrating with Azure OpenAI and a vector database. This serves as a robust example for building your own GenAI applications.
*   **Containerization & Orchestration:** Dockerfile and Kubernetes deployment configurations for efficient packaging and orchestration of the application and its dependencies on AKS.
*   **Comprehensive Documentation:** Detailed guidance covering deployment, configuration, local development, and contribution, designed to facilitate understanding and adoption.

## Project Structure

This project is organized into two main components: `infra` for infrastructure-as-code and `app` for the RAG chatbot application. Each component follows a modular design to enhance readability, maintainability, and reusability.

```
GenAI-Starter-Stack/
├── app/                     # RAG Chatbot Application Code
│   ├── src/                 # Source code for the FastAPI application
│   │   ├── api/             # Defines FastAPI routes and API endpoints
│   │   ├── config/          # Centralized application configuration
│   │   ├── models/          # Pydantic data models
│   │   ├── services/        # Core RAG logic and external service integrations
│   │   └── main.py          # Main FastAPI application entry point
│   ├── static/              # Static files for the chat UI
│   │   ├── index.html       # Main HTML file for the UI
│   │   ├── script.js        # JavaScript for chat functionality
│   │   └── style.css        # CSS for UI styling
│   ├── tests/               # Unit tests for the application
│   │   └── test_rag_service.py # Tests for the RAG service
│   ├── chatbot-deployment.yaml # Kubernetes Deployment for the chatbot
│   ├── chatbot-hpa.yaml      # Kubernetes Horizontal Pod Autoscaler
│   ├── secretproviderclass.yaml   # Kubernetes SecretProviderClass for Azure Key Vault integration
│   ├── chatbot-service.yaml    # Kubernetes Service for the chatbot
│   ├── Dockerfile           # Dockerfile for containerizing the application
│   ├── qdrant-deployment.yaml  # Kubernetes Deployment for Qdrant
│   ├── qdrant-service.yaml     # Kubernetes Service for Qdrant
│   └── requirements.txt     # Python dependencies
├── infra/                   # Terraform Infrastructure as Code
│   ├── modules/             # Reusable Terraform modules
│   │   ├── acr/             # Azure Container Registry module
│   │   ├── aks/             # Module for deploying Azure Kubernetes Service clusters
│   │   ├── bastion/         # Module for deploying Azure Bastion hosts
│   │   ├── jumpbox/         # Module for deploying Linux Jump Box Virtual Machines
│   │   ├── network/         # Module for defining Azure Networking (Virtual Networks, Subnets)
│   │   ├── openai/          # Module for deploying Azure OpenAI Service accounts and deployments
│   │   └── resource_group/  # Module for creating and managing Azure Resource Groups
│   ├── acr.tf               # Root configuration: Calls the `acr` module to deploy Azure Container Registry
│   ├── aks.tf               # Root configuration: Calls the `aks` module to deploy Azure Kubernetes Service
│   ├── bastion.tf           # Root module call for Bastion
│   ├── jumpbox.tf           # Root module call for Jump Box
│   ├── main.tf              # Main Terraform configuration file, orchestrating calls to various modules
│   ├── network.tf           # Root module call for Networking
│   ├── openai.tf            # Root module call for Azure OpenAI
│   ├── outputs.tf           # Defines Terraform outputs, providing access to deployed resource attributes
│   └── variables.tf         # Defines Terraform input variables for the root module
└── README.md                # This comprehensive project documentation file
```

## Architecture

The architecture has been enhanced with several enterprise-grade features to improve security, scalability, and observability.

### Infrastructure Architecture

*   **Azure Resource Group (`resource_group` module):** The foundational logical container that holds all the Azure resources deployed by this stack, facilitating easy management and lifecycle operations.
*   **Azure Virtual Network (VNet) & Subnets (`network` module):** Provides a secure and isolated network environment for all deployed resources. It includes:
    *   A primary VNet (`GenAI-VNet`).
    *   A dedicated subnet for the AKS cluster (`AKSSubnet`).
    *   A dedicated subnet for Azure Bastion (`AzureBastionSubnet`), ensuring network isolation for management services.
*   **Azure Kubernetes Service (AKS) Cluster (`aks` module):** The core compute platform for containerized applications. It hosts the RAG chatbot and the vector database, providing managed Kubernetes capabilities. The AKS cluster is configured as a **private cluster**, meaning its API server is not exposed to the public internet, enhancing security. Nodes are deployed into `AKSSubnet`.
*   **Azure Container Registry (ACR) (`acr` module):** A fully managed Docker image registry used to securely store and manage the container images for the chatbot application. It integrates seamlessly with AKS for image pulling.
*   **Azure OpenAI Service (`openai` module):** Provides access to powerful Large Language Models (LLMs) (e.g., GPT-4o for chat, `text-embedding-ada-002` for embeddings) for natural language understanding, generation, and text embedding. This service is integrated securely within your Azure environment, allowing your applications to leverage cutting-edge AI capabilities.
*   **Qdrant (Vector Database):** Deployed as a container within the AKS cluster, Qdrant efficiently stores and retrieves vector embeddings. It is crucial for the RAG pattern, enabling semantic search and retrieval of relevant documents based on user queries.
*   **Azure Bastion (`bastion` module):** A fully managed PaaS service that provides secure and seamless RDP/SSH connectivity to virtual machines within the VNet directly through the Azure portal or via native SSH clients. It eliminates the need for public IP addresses on VMs, significantly reducing the attack surface.
*   **Jump Box VM (`jumpbox` module):** A Linux virtual machine deployed within the same VNet as the AKS cluster. It serves as a secure jump point for `kubectl` access to the private AKS API server, as direct access from outside the VNet is restricted.

### Application Architecture (RAG Chatbot)

The application architecture now includes a user interface and several production-readiness features:

*   **Frontend (Chat UI):** A new `static` directory contains the HTML, CSS, and JavaScript files for a user-friendly chat interface, served directly by the FastAPI backend.
*   **Backend (FastAPI):**
    *   **`src/main.py`:** Now serves the static frontend files, includes a `/health` endpoint for Kubernetes probes, and exposes a `/metrics` endpoint for Prometheus.
    *   **`src/services/rag_service.py`:** Core RAG logic remains the same.
*   **Enterprise Features:**
    *   **Security:** Sensitive credentials (like Azure OpenAI API Key and Endpoint) are now securely managed using **Azure Key Vault**. The AKS cluster's managed identity is granted access to Key Vault secrets. The Secrets Store CSI Driver for Kubernetes is used to mount these secrets directly into the application pods as files, ensuring that sensitive information is never exposed as environment variables or stored directly in Kubernetes manifests. The `secretproviderclass.yaml` defines how these secrets are retrieved from Key Vault.
    *   **Scalability:** The `chatbot-hpa.yaml` file defines a Horizontal Pod Autoscaler that automatically scales the number of chatbot pods based on CPU utilization.
    *   **Resilience:** The `chatbot-deployment.yaml` includes liveness and readiness probes pointing to the `/health` endpoint. This allows Kubernetes to automatically manage pod health, restarting unhealthy pods and only routing traffic to ready ones.
    *   **Observability:** The application is instrumented with `prometheus-fastapi-instrumentator` to expose metrics at `/metrics` and uses `structlog` for structured JSON logging, which is easier to parse and analyze in a log aggregation system.
    *   **Testing:** The `tests` directory contains unit tests for the `RAGService`, which can be run to ensure code quality and prevent regressions.

## Deployment Steps

Follow these detailed steps to deploy the GenAI Starter Stack to your Azure subscription. This process involves provisioning infrastructure with Terraform and deploying the containerized application to AKS.

### Prerequisites

Ensure you have the following tools installed and configured on your local machine:

*   **Azure Subscription:** An active Azure subscription with sufficient permissions to create resources.
*   **Azure CLI:** Version 2.30.0 or later. [Installation Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    *   Log in to your Azure account: `az login`
    *   Set your default subscription: `az account set --subscription "<Your Subscription Name or ID>"`
*   **Terraform:** Version 1.0.0 or later. [Installation Guide](https://learn.hashicorp.com/terraform/getting-started/install)
*   **Docker Desktop:** Required for building and pushing Docker images. Ensure it's running. [Installation Guide](https://docs.docker.com/desktop/install/)
*   **`kubectl`:** Kubernetes command-line tool. [Installation Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
*   **SSH Key Pair:** A public and private SSH key pair for connecting to the jump box VM. If you don't have one, generate it using `ssh-keygen`.
*   **Secrets Store CSI Driver:** This driver is required for AKS to integrate with Azure Key Vault. Install it on your AKS cluster using the following command:
    ```bash
    az aks enable-addons --addons azure-keyvault-secrets-provider --name <your-aks-cluster-name> --resource-group <your-resource-group-name>
    ```

### 1. Clone the Repository

```bash
git clone <repository-url>
cd GenAI-Starter-Stack
```

### 2. Configure Terraform Variables

Navigate to the `infra` directory and create a `terraform.tfvars` file. This file will hold sensitive or environment-specific variables that override the defaults defined in `variables.tf`. This is the primary place to customize your deployment.

```bash
cd infra
nano terraform.tfvars
```

Add the following content to `terraform.tfvars`, replacing placeholders with your actual values. Ensure `jumpbox_ssh_public_key` matches the content of your public SSH key file (e.g., `~/.ssh/id_ed25519.pub`).

```terraform
resource_group_name = "GenAI-Starter-Stack-RG"
location            = "East US" # Or your preferred Azure region (e.g., "West US", "North Europe")

# Public SSH key for the Jump Box VM. This is crucial for SSH access.
jumpbox_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7gIGbBj+JvJVMraEscRfDOdoLbxnw6Nwy4IKljxrfJ gauravsingh@Gauravs-Mac-Book-Air.local"

# Optional: Common tags to apply to all resources for cost management and organization
common_tags = {
  environment = "dev"
  project     = "GenAIStarterStack"
  owner       = "your-email@example.com"
}

# Optional: Override default names for resources
aks_cluster_name = "GenAI-AKS-Cluster"
openai_account_name = "genai-openai-account"

# Optional: Override default network settings if needed
vnet_name = "GenAI-VNet"
vnet_address_space = ["10.0.0.0/16"]
aks_subnet_name = "AKSSubnet"
aks_subnet_address_prefix = "10.0.1.0/24"
azure_bastion_subnet_address_prefix = "10.0.2.0/26"
```

### 3. Initialize and Apply Terraform

From the `infra` directory, initialize Terraform to download necessary providers and modules. This step is crucial after cloning the repository or making changes to module configurations.

```bash
terraform init
```

Then, apply the Terraform configuration to provision the Azure resources. This command will display a plan of changes and prompt for confirmation before creating resources.

```bash
terraform apply
```

Alternatively, to skip the confirmation prompt (use with caution in production environments):

```bash
terraform apply -auto-approve
```

This step will provision all the necessary Azure resources as defined in the modular Terraform code, including:
*   Azure Resource Group: The top-level container for all resources.
*   Azure Virtual Network and Subnets: Configured for AKS and Bastion.
*   Azure Kubernetes Service (AKS) Cluster: A private cluster for secure container orchestration.
*   Azure Container Registry (ACR): For storing Docker images.
*   Azure OpenAI Service: With deployed models for chat (`gpt-4o`) and embeddings (`text-embedding-ada-002`).
*   Linux Jump Box VM: A secure, private VM for managing the AKS cluster.
*   Azure Bastion Host: For secure, browser-based or native client SSH access to the Jump Box.

**Note:** This infrastructure provisioning process can take a significant amount of time (typically 15-30 minutes or more) to complete, especially for the AKS cluster and Bastion host.

### 4. Connect to the Jump Box VM

Once Terraform apply is complete, you will connect to the Jump Box VM using Azure Bastion from your local terminal. This VM will serve as your secure gateway to interact with your private AKS cluster.

First, ensure you have the `bastion` extension for Azure CLI installed on your local machine:

```bash
az extension add --name bastion
```

Then, connect to the Jump Box. Replace `GenAI-VNet-bastion` with the actual name of your Bastion host if you customized it (you can find its name in the Terraform outputs after `terraform apply`). Ensure the `--ssh-key` path points to your **private SSH key**.

```bash
az network bastion ssh \
  --name GenAI-VNet-bastion \
  --resource-group GenAI-Starter-Stack-RG \
  --target-resource-id $(az vm show --name GenAI-Starter-Stack-RG-jumpbox-vm --resource-group GenAI-Starter-Stack-RG --query id --output tsv) \
  --auth-type ssh-key \
  --username azureuser \
  --ssh-key ~/.ssh/id_ed25519 # Path to your private SSH key (e.g., ~/.ssh/id_rsa or ~/.ssh/passkey)
```

### 5. Prepare the Jump Box and Deploy Kubernetes Manifests

Once successfully connected to the Jump Box VM via SSH, execute the following steps **inside the Jump Box terminal**:

#### 5.1. Install `kubectl` and Azure CLI

These tools are essential for managing Kubernetes and Azure resources from the jump box. Run these commands sequentially:

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
sudo apt-get update
sudo apt-get install -y kubectl

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

#### 5.2. Configure `kubectl` for AKS

Fetch the credentials for your AKS cluster and configure `kubectl` to interact with it. This command will merge the AKS cluster context into your `kubeconfig` file on the jump box.

```bash
az aks get-credentials --resource-group GenAI-Starter-Stack-RG --name GenAI-AKS-Cluster --overwrite-existing
```

#### 5.3. Build and Push Docker Image

From your **local machine's terminal** (where your project files are), build the Docker image for the chatbot application and push it to your Azure Container Registry (ACR). This step is performed locally because Docker Desktop is typically installed on your development machine.

First, retrieve your ACR login server. This is needed to tag your Docker image correctly.

```bash
az acr show --name genaistarterstackacr --query loginServer --output tsv
```

Log in to your ACR. This authenticates your Docker client with ACR.

```bash
az acr login --name genaistarterstackacr
```

Build and tag the Docker image. Replace `<ACR_LOGIN_SERVER>` with the output from the `az acr show` command.

```bash
docker build --platform linux/amd64 -t <ACR_LOGIN_SERVER>/chatbot:latest ./app
```

Push the image to ACR. This makes your application image available for AKS to pull.

```bash
docker push <ACR_LOGIN_SERVER>/chatbot:latest
```

#### 5.4. Transfer Kubernetes Manifests

From your **local machine**, copy all the necessary YAML files from the `app` directory to the jump box.

```bash
# On your local machine, create the files on the jump box
# For each file, open nano <filename.yaml> on the jump box, paste content, save, and exit.
# qdrant-deployment.yaml, qdrant-service.yaml
# chatbot-deployment.yaml, chatbot-service.yaml, chatbot-hpa.yaml, secretproviderclass.yaml
```

#### 5.5. Deploy SecretProviderClass and Application to AKS

Switch back to your **jump box terminal**. Apply the `secretproviderclass.yaml` first, then the remaining Kubernetes manifests:

```bash
# Deploy SecretProviderClass
kubectl apply -f secretproviderclass.yaml

# Deploy Qdrant
kubectl apply -f qdrant-deployment.yaml
kubectl apply -f qdrant-service.yaml

# Deploy the Chatbot Application, Service, and HPA
kubectl apply -f chatbot-deployment.yaml
kubectl apply -f chatbot-service.yaml
kubectl apply -f chatbot-hpa.yaml
```

### 6. Verify Deployment and Access UI

Verify that the pods are running:

```bash
kubectl get pods
kubectl get hpa
```

To access the chatbot UI, you need to forward the port of the `chatbot` service to your local machine from the jump box.

First, find the name of the chatbot service:
```bash
kubectl get services
```

Then, use `kubectl port-forward` to forward a local port (e.g., 8080) to the service's port (80). Run this command **in your jump box terminal** and keep it running.

```bash
kubectl port-forward service/chatbot 8080:80
```

Now, open a new **local terminal** (not the jump box one) and forward that same port from the jump box to your local machine. You will need to re-run the `az network bastion ssh` command with an `-L` flag for port forwarding.

```bash
# This command is run on your local machine
az network bastion ssh \
  --name GenAI-VNet-bastion \
  --resource-group GenAI-Starter-Stack-RG \
  --target-resource-id $(az vm show --name GenAI-Starter-Stack-RG-jumpbox-vm --resource-group GenAI-Starter-Stack-RG --query id --output tsv) \
  --auth-type ssh-key \
  --username azureuser \
  --ssh-key ~/.ssh/id_ed25519 \
  -L 8080:localhost:8080
```

Once connected, you can access the chatbot UI in your local browser at **http://localhost:8080**.


### 7. Clean Up Resources (Optional)

To avoid incurring unnecessary costs, you can destroy all the deployed Azure resources when you are finished.
This will remove everything provisioned by Terraform.

From your **local machine's `infra` directory**:

```bash
terraform destroy -auto-approve
```

## Application Configuration

The RAG Chatbot application's configuration is managed robustly via Pydantic's `BaseSettings` and environment variables. Sensitive credentials are now sourced from Azure Key Vault in the Kubernetes deployment.

*   **Azure OpenAI Credentials:** In the Kubernetes deployment, `OPENAI_API_KEY` and `OPENAI_ENDPOINT` are read directly from files mounted by the Secrets Store CSI Driver (e.g., `/mnt/secrets-store/openai-api-key`). For local development, these can still be provided via environment variables or a `.env` file.
*   `QDRANT_HOST`: The hostname or IP address of the Qdrant service. Within Kubernetes, this will typically be the service name (default: `qdrant`).
*   `QDRANT_PORT`: The port of the Qdrant service (default: `6333`).

## Local Development

The local development process is updated to include running tests and accessing the new UI.

1.  **Prerequisites:**
    *   Python 3.9+
    *   Docker Desktop (for Qdrant)

2.  **Install Python Dependencies:**
    Navigate to the `app` directory and install the required packages, including the new ones for testing and monitoring.
    ```bash
    cd app
    pip install -r requirements.txt
    ```

3.  **Run Local Qdrant (Docker):**
    ```bash
    docker run -p 6333:6333 -p 6334:6334 qdrant/qdrant
    ```

4.  **Local Configuration (for Qdrant only):**
    If you are running Qdrant locally, you don't need to create a `.env` file for OpenAI credentials as they are now read from mounted files in the Kubernetes deployment. However, if you need to override Qdrant host/port for local testing, you can still use environment variables or modify `src/config/settings.py` directly.

5.  **Run Unit Tests (Optional):**
    From the `app` directory, run the unit tests:
    ```bash
    python -m unittest discover tests
    ```

6.  **Run the FastAPI Application Locally:**
    From the `app` directory, start the FastAPI application:
    ```bash
    uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
    ```
    The application will be accessible at `http://127.0.0.1:8000`. The chat UI is available at the root URL, and the OpenAPI docs are at `/docs`.

## Troubleshooting

### Qdrant Indexing Error: Invalid Point ID

**Symptom:**

When attempting to index a document, the application returns a `500 Internal Server Error`, and the chatbot pod logs show the following error:

```
qdrant_client.http.exceptions.UnexpectedResponse: Unexpected Response: 400 (Bad Request)
Raw response content:
b'{"status":{"error":"Format error in JSON body: value <some-large-number> is not a valid point ID, valid values are either an unsigned integer or a UUID"},"time":0.0}'
```

**Cause:**

The `hash()` function in Python, which was previously used to generate document IDs, can produce negative integers. Qdrant, however, requires point IDs to be either a non-negative integer or a valid UUID. This mismatch causes the indexing operation to fail.

**Resolution:**

The application has been updated to use the `uuid` library to generate a unique UUID for each document. This ensures that the point IDs are always in a format that Qdrant accepts.

If you encounter this issue, ensure your application code in `app/src/services/rag_service.py` uses `uuid.uuid4()` to generate the ID for each point, as shown in the updated source code.

### Redeploying the Application

When you make changes to the application code, you need to rebuild the Docker image and redeploy the application to your AKS cluster for the changes to take effect. Because the Docker image is tagged with `:latest`, you must delete the existing pod to force Kubernetes to pull the new image.

1.  **Build and Push the Docker Image:** Follow the instructions in section 5.3 to build and push the updated Docker image to your Azure Container Registry.

2.  **Delete the Chatbot Pod:** From your jump box, find the name of your `chatbot` pod:

    ```bash
    kubectl get pods
    ```

    Then, delete the pod to trigger a redeployment:

    ```bash
    kubectl delete pod <chatbot-pod-name>
    ```

    Kubernetes will automatically create a new pod, which will pull the latest version of the Docker image.

## Contributing

We welcome and appreciate contributions to enhance this GenAI Starter Stack. To contribute, please follow these guidelines:

*   **Fork the Repository:** Start by forking the main repository to your GitHub account.
*   **Create a New Branch:** For each new feature or bug fix, create a dedicated branch from `main` (e.g., `feature/new-rag-model` or `bugfix/fix-qdrant-connection`).
*   **Adhere to Standards:** Ensure your code adheres to the existing style, quality, and architectural standards of the project (e.g., Python Black for formatting, clear Terraform module definitions).
*   **Write Clear Commit Messages:** Use descriptive commit messages that explain the purpose and scope of your changes.
*   **Test Your Changes:** If applicable, include unit and integration tests for your new features or bug fixes.
*   **Submit a Pull Request:** Once your changes are complete and tested, submit a pull request to the `main` branch of the original repository. Provide a detailed description of your changes, their purpose, and any relevant testing information.