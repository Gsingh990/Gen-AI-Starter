# GenAI Starter Stack

## Executive Summary

This GenAI Starter Stack provides a comprehensive, production-ready foundation for building and deploying Retrieval-Augmented Generation (RAG) chatbots and other GenAI-powered applications on Microsoft Azure. It leverages a powerful combination of Azure-native services and popular open-source technologies, orchestrated through enterprise-grade Infrastructure-as-Code (IaC) and a modular application architecture. This stack significantly accelerates the development and deployment of custom GenAI solutions, reducing time-to-value by providing a secure, scalable, and cost-effective blueprint.

## Project Overview

The primary purpose of this GenAI Starter Stack is to empower organizations to rapidly develop and deploy intelligent applications capable of interacting with and providing answers based on their proprietary data. While the included example is a RAG chatbot, the underlying infrastructure and application patterns are designed to be flexible and extensible for various GenAI use cases.

**Key Capabilities of the Stack:**

*   **Accelerated Development & Deployment:** Provides a ready-to-deploy template, significantly reducing the effort and time required to go from concept to a functional GenAI application.
*   **Contextual Understanding & Accurate Responses (RAG Pattern):** The RAG pattern, demonstrated by the chatbot, allows applications to retrieve relevant information from a knowledge base and use that information to generate more precise, factual, and contextually appropriate answers, minimizing LLM hallucinations.
*   **Secure & Isolated Environment:** The architecture prioritizes data privacy and security by leveraging Azure's private networking capabilities and secure access controls, keeping sensitive data within your Azure environment.
*   **Scalability & Reliability:** Built on Azure Kubernetes Service (AKS) and other managed Azure services, the solution can scale horizontally to meet varying demand and offers high availability.
*   **Modular & Maintainable Codebase:** Both the infrastructure (Terraform) and application (FastAPI) are designed with modularity, separation of concerns, and best practices in mind, promoting long-term maintainability and extensibility.

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
│   │   ├── config/          # Centralized application configuration using Pydantic BaseSettings
│   │   ├── models/          # Pydantic data models
│   │   ├── services/        # Core RAG logic and external service integrations (OpenAI, Qdrant)
│   │   └── main.py          # Main FastAPI application entry point
│   ├── Dockerfile           # Dockerfile for containerizing the application
│   ├── requirements.txt     # Python dependencies
│   ├── chatbot-deployment.yaml # Kubernetes Deployment for the chatbot
│   ├── chatbot-service.yaml    # Kubernetes Service for the chatbot
│   ├── qdrant-deployment.yaml  # Kubernetes Deployment for Qdrant
│   └── qdrant-service.yaml     # Kubernetes Service for Qdrant
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

The GenAI Starter Stack is built on a modern, cloud-native architecture designed for performance, scalability, and security. The entire infrastructure is provisioned using modular Terraform configurations, ensuring consistency, reusability, and adherence to Infrastructure-as-Code principles.

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

The RAG Chatbot application is built using Python with the FastAPI framework, following a clean, modular, and enterprise-grade architecture:

*   **`src/main.py`:** The primary entry point for the FastAPI application. It initializes the FastAPI app instance and includes the API routes defined in `src/api/routes.py`.
*   **`src/api/routes.py`:** Defines the RESTful API endpoints (`/query` and `/index`) for the chatbot. It uses FastAPI's dependency injection to obtain an instance of `RAGService`.
*   **`src/services/rag_service.py`:** Encapsulates the core RAG logic. This service is responsible for:
    *   Initializing OpenAI and Qdrant clients.
    *   Handling query embedding using Azure OpenAI's embedding models.
    *   Performing similarity searches in Qdrant to retrieve relevant documents.
    *   Constructing augmented prompts for the LLM based on retrieved context.
    *   Generating responses using Azure OpenAI's chat models.
    *   Indexing new documents by embedding them and storing them in Qdrant.
*   **`src/models/models.py`:** Contains Pydantic models (`Query`, `Document`) that define the data structures for API requests and responses, ensuring data validation and clear contracts.
*   **`src/config/settings.py`:** Centralizes application configuration using Pydantic's `BaseSettings`. This allows environment variables to be loaded and validated automatically, providing a robust and flexible way to manage settings (e.g., API keys, endpoints).

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

From your **local machine's terminal**, copy the Kubernetes YAML files (`qdrant-deployment.yaml`, `qdrant-service.yaml`, `chatbot-deployment.yaml`, `chatbot-service.yaml`) to the jump box. This is necessary because the jump box is where you will run `kubectl apply`.

Replace `<JUMPBOX_PRIVATE_IP>` with the private IP of your jump box. You can find this in the Azure portal under the VM's networking blade, or by running `az vm show --name GenAI-Starter-Stack-RG-jumpbox-vm --resource-group GenAI-Starter-Stack-RG --query privateIps --output tsv` on your local machine.

```bash
# Manual file creation on Jump Box (due to SCP/AZ CLI transfer issues)
# For each file, open nano <filename.yaml> on the jump box, paste content, save, and exit.
# qdrant-deployment.yaml
# qdrant-service.yaml
# chatbot-deployment.yaml
# chatbot-service.yaml
```

#### 5.5. Edit Chatbot Deployment Configuration

Switch back to your **jump box terminal**. Edit the `chatbot-deployment.yaml` file to include your Azure OpenAI API Key and Endpoint. These are sensitive values and should be retrieved securely from your Azure OpenAI resource in the Azure portal.

```bash
nano chatbot-deployment.yaml
```

Locate the `env:` section and replace the placeholder values:

```yaml
        env:
        - name: OPENAI_API_KEY
          value: "YOUR_AZURE_OPENAI_API_KEY" # Replace with your actual Azure OpenAI API Key
        - name: OPENAI_ENDPOINT
          value: "YOUR_AZURE_OPENAI_ENDPOINT" # Replace with your actual Azure OpenAI Endpoint (e.g., https://<your-openai-account>.openai.azure.com/)
```

Save the file (Ctrl+O, Enter, Ctrl+X in nano).

#### 5.6. Deploy Qdrant and Chatbot to AKS

From your **jump box terminal**, apply the Kubernetes manifests to deploy the Qdrant vector database and the RAG chatbot application to your AKS cluster:

```bash
kubectl apply -f qdrant-deployment.yaml
kubectl apply -f qdrant-service.yaml
kubectl apply -f chatbot-deployment.yaml
kubectl apply -f chatbot-service.yaml
```

### 6. Verify Deployment

From your **jump box terminal**, verify that the deployments were successful and the pods are running:

```bash
kubectl get pods
kubectl get services
```

Look for `qdrant` and `chatbot` pods in a `Running` state. For services, check if the `chatbot` service has an external IP (if configured as LoadBalancer) or a ClusterIP (if internal).

### 7. Clean Up Resources (Optional)

To avoid incurring unnecessary costs, you can destroy all the deployed Azure resources when you are finished.
This will remove everything provisioned by Terraform.

From your **local machine's `infra` directory**:

```bash
terraform destroy -auto-approve
```

## Application Configuration

The RAG Chatbot application uses environment variables for configuration, managed robustly via Pydantic's `BaseSettings`. These variables are typically injected into the Kubernetes deployment manifest or provided during local development.

*   `OPENAI_API_KEY`: Your Azure OpenAI API key. This is a sensitive credential and should be handled securely (e.g., Kubernetes Secrets).
*   `OPENAI_ENDPOINT`: Your Azure OpenAI endpoint (e.g., `https://<your-openai-account>.openai.azure.com/`).
*   `QDRANT_HOST`: The hostname or IP address of the Qdrant service. Within Kubernetes, this will typically be the service name (default: `qdrant`).
*   `QDRANT_PORT`: The port of the Qdrant service (default: `6333`).

## Local Development

To set up the RAG Chatbot application for local development and testing without deploying to Azure:

1.  **Prerequisites:**
    *   Python 3.9+ installed on your local machine.
    *   Docker Desktop installed and running (for local Qdrant instance).

2.  **Install Python Dependencies:**

    Navigate to the `app` directory and install the required Python packages:

    ```bash
    cd app
    pip install -r requirements.txt
    ```

3.  **Run Local Qdrant (Docker):**

    Start a local instance of the Qdrant vector database using Docker. This will expose Qdrant on ports 6333 (gRPC) and 6334 (HTTP).

    ```bash
    docker run -p 6333:6333 -p 6334:6334 qdrant/qdrant
    ```

4.  **Create `.env` file for Local Configuration:**

    Create a `.env` file in the `app/src` directory. This file will hold your Azure OpenAI credentials for local testing. **Do not commit this file to Git.**

    ```
    OPENAI_API_KEY="YOUR_AZURE_OPENAI_API_KEY"
    OPENAI_ENDPOINT="YOUR_AZURE_OPENAI_ENDPOINT"
    ```

5.  **Run the FastAPI Application Locally:**

    Navigate to the `app` directory and start the FastAPI application. The `--reload` flag enables hot-reloading during development.

    ```bash
    uvicorn src.main:app --reload
    ```

    The FastAPI application will be accessible at `http://127.0.0.1:8000`. You can test the API endpoints (e.g., `/docs` for Swagger UI) in your browser.

## Contributing

We welcome and appreciate contributions to enhance this GenAI Starter Stack. To contribute, please follow these guidelines:

*   **Fork the Repository:** Start by forking the main repository to your GitHub account.
*   **Create a New Branch:** For each new feature or bug fix, create a dedicated branch from `main` (e.g., `feature/new-rag-model` or `bugfix/fix-qdrant-connection`).
*   **Adhere to Standards:** Ensure your code adheres to the existing style, quality, and architectural standards of the project (e.g., Python Black for formatting, clear Terraform module definitions).
*   **Write Clear Commit Messages:** Use descriptive commit messages that explain the purpose and scope of your changes.
*   **Test Your Changes:** If applicable, include unit and integration tests for your new features or bug fixes.
*   **Submit a Pull Request:** Once your changes are complete and tested, submit a pull request to the `main` branch of the original repository. Provide a detailed description of your changes, their purpose, and any relevant testing information.