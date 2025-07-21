# GenAI Starter Stack

## Executive Summary

This GenAI Starter Stack provides a comprehensive, production-ready foundation for building and deploying Retrieval-Augmented Generation (RAG) chatbots on Microsoft Azure. It leverages a powerful combination of Azure-native services and popular open-source technologies to deliver a scalable, secure, and cost-effective solution. By providing a pre-built infrastructure-as-code template and a functional chatbot application, this starter stack significantly accelerates the development and deployment of custom GenAI solutions, reducing the time-to-value from months to a matter of days.

## Project Overview

The primary purpose of this GenAI Starter Stack is to empower organizations to rapidly develop and deploy intelligent chatbots capable of interacting with and providing answers based on their proprietary data. This is achieved through the implementation of the Retrieval-Augmented Generation (RAG) pattern, which combines the strengths of large language models (LLMs) with external knowledge retrieval systems.

**Key Capabilities:**

*   **Contextual Understanding:** Chatbots can understand user queries and retrieve relevant information from a vectorized knowledge base.
*   **Accurate and Relevant Responses:** By augmenting LLM prompts with retrieved context, the chatbot generates more precise, factual, and contextually appropriate answers, minimizing hallucinations.
*   **Data Privacy and Security:** The architecture is designed to keep sensitive data within your Azure environment, leveraging private networking and secure access controls.
*   **Scalability and Reliability:** Built on Azure Kubernetes Service (AKS), the solution can scale horizontally to meet varying demand and offers high availability.
*   **Accelerated Development:** Provides a ready-to-deploy template, reducing the effort and time required to go from concept to a functional RAG chatbot.

This project provides the following:

*   **Infrastructure as Code (IaC):** A complete set of Terraform modules to provision the necessary Azure infrastructure, ensuring repeatable and consistent deployments.
*   **RAG Chatbot Application:** A functional chatbot application built with Python and FastAPI, demonstrating the RAG pattern by integrating with Azure OpenAI and a vector database.
*   **Containerization:** Dockerfile and Kubernetes deployment configurations for running the chatbot application and vector database on Azure Kubernetes Service (AKS).
*   **Documentation:** Comprehensive documentation to guide you through the deployment, customization, and operation of the stack.

## Architecture

The GenAI Starter Stack is built on a modern, cloud-native architecture designed for performance, scalability, and security:

*   **Azure Kubernetes Service (AKS):** Serves as the compute platform for deploying, scaling, and managing the containerized chatbot application and the vector database. It provides a managed Kubernetes environment, abstracting away the complexities of cluster management.
*   **Azure OpenAI Service:** Provides access to powerful large language models (LLMs) (e.g., GPT-4o, GPT-3.5 Turbo) for natural language understanding, generation, and text embedding. This service is integrated securely within your Azure environment.
*   **Qdrant/Pinecone on AKS:** A choice of two popular open-source vector databases (Qdrant is deployed by default in the provided code) for efficient storage and retrieval of vector embeddings. These databases are deployed as containers within the AKS cluster, enabling low-latency data access for the RAG process.
*   **Azure Virtual Network (VNet):** Provides a secure and isolated network environment for all the deployed resources. Private endpoints and private IP addresses are utilized where possible to enhance security and minimize exposure to the public internet.
*   **Azure Container Registry (ACR):** A managed Docker image registry used to store and manage the container images for the chatbot application.
*   **Azure Bastion (Optional but Recommended):** For secure access to private virtual machines (like the jump box), Azure Bastion provides a secure RDP/SSH connection directly through the Azure portal or via native SSH clients, eliminating the need for public IP addresses on VMs.
*   **Jump Box VM (Optional but Recommended for Private AKS):** A Linux virtual machine deployed within the same VNet as the AKS cluster, used as a secure jump point to interact with the private AKS API server using `kubectl`.

## Deployment Steps

Follow these detailed steps to deploy the GenAI Starter Stack to your Azure subscription.

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

Navigate to the `infra` directory and create a `terraform.tfvars` file. This file will hold sensitive or environment-specific variables.

```bash
cd infra
nano terraform.tfvars
```

Add the following content to `terraform.tfvars`, replacing placeholders with your actual values:

```terraform
resource_group_name = "GenAI-Starter-Stack-RG"
location            = "East US" # Or your preferred Azure region

# Ensure this matches your public SSH key content
jumpbox_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7gIGbBj+JvJVMraEscRfDOdoLbxnw6Nwy4IKljxrfJ gauravsingh@Gauravs-Mac-Book-Air.local"
```

### 3. Initialize and Apply Terraform

From the `infra` directory:

```bash
terraform init
terraform apply -auto-approve
```

This step will provision all the necessary Azure resources, including:
*   Resource Group
*   Virtual Network and Subnets (for AKS, Bastion)
*   Azure Kubernetes Service (AKS) Cluster (private)
*   Azure Container Registry (ACR)
*   Azure OpenAI Service with `gpt-4o` and `text-embedding-ada-002` deployments
*   Linux Jump Box VM (private IP only)
*   Azure Bastion Host (for secure access to the Jump Box)

**Note:** This process can take 15-30 minutes to complete.

### 4. Connect to the Jump Box VM

Once Terraform apply is complete, you will connect to the Jump Box VM using Azure Bastion from your local terminal. This VM will be used to interact with your private AKS cluster.

First, ensure you have the `bastion` extension for Azure CLI:

```bash
az extension add --name bastion
```

Then, connect to the Jump Box. Replace `GenAI-VNet-bastion` with the actual name of your Bastion host if it's different (it should be in your Terraform outputs).

```bash
az network bastion ssh \
  --name GenAI-VNet-bastion \
  --resource-group GenAI-Starter-Stack-RG \
  --target-resource-id $(az vm show --name GenAI-Starter-Stack-RG-jumpbox-vm --resource-group GenAI-Starter-Stack-RG --query id --output tsv) \
  --auth-type ssh-key \
  --username azureuser \
  --ssh-key ~/.ssh/id_ed25519 # Path to your private SSH key
```

### 5. Prepare the Jump Box and Deploy Kubernetes Manifests

Once connected to the Jump Box VM via SSH, execute the following steps **inside the Jump Box terminal**:

#### 5.1. Install `kubectl` and Azure CLI

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null && sudo apt-get update && sudo apt-get install -y kubectl

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

#### 5.2. Configure `kubectl` for AKS

```bash
az aks get-credentials --resource-group GenAI-Starter-Stack-RG --name GenAI-AKS-Cluster --overwrite-existing
```

#### 5.3. Transfer Kubernetes Manifests

From your **local machine's terminal** (not the jump box), copy the Kubernetes YAML files to the jump box. Replace `<JUMPBOX_PRIVATE_IP>` with the private IP of your jump box (you can find this in the Azure portal under the VM's networking blade).

```bash
scp -i ~/.ssh/id_ed25519 /path/to/GenAI-Starter-Stack/app/qdrant-deployment.yaml azureuser@<JUMPBOX_PRIVATE_IP>:/home/azureuser/
scp -i ~/.ssh/id_ed25519 /path/to/GenAI-Starter-Stack/app/qdrant-service.yaml azureuser@<JUMPBOX_PRIVATE_IP>:/home/azureuser/
scp -i ~/.ssh/id_ed25519 /path/to/GenAI-Starter-Stack/app/chatbot-deployment.yaml azureuser@<JUMPBOX_PRIVATE_IP>:/home/azureuser/
scp -i ~/.ssh/id_ed25519 /path/to/GenAI-Starter-Stack/app/chatbot-service.yaml azureuser@<JUMPBOX_PRIVATE_IP>:/home/azureuser/
```

#### 5.4. Edit Chatbot Deployment Configuration

Switch back to your **jump box terminal**. Edit the `chatbot-deployment.yaml` file to include your Azure OpenAI API Key and Endpoint. You can get these from the Azure portal under your Azure OpenAI resource.

```bash
nano chatbot-deployment.yaml
```

Locate the `env:` section and replace the placeholder values:

```yaml
        env:
        - name: OPENAI_API_KEY
          value: "YOUR_OPENAI_API_KEY" # Replace with your actual key
        - name: OPENAI_ENDPOINT
          value: "YOUR_OPENAI_ENDPOINT" # Replace with your actual endpoint
```

Save the file (Ctrl+O, Enter, Ctrl+X in nano).

#### 5.5. Deploy Qdrant and Chatbot to AKS

From your **jump box terminal**:

```bash
kubectl apply -f qdrant-deployment.yaml
kubectl apply -f qdrant-service.yaml
kubectl apply -f chatbot-deployment.yaml
kubectl apply -f chatbot-service.yaml
```

### 6. Verify Deployment

From your **jump box terminal**:

```bash
kubectl get pods
kubectl get services
```

Look for `qdrant` and `chatbot` pods in a `Running` state and services with external IPs (for the chatbot if exposed publicly).

### 7. Clean Up Resources (Optional)

To avoid incurring unnecessary costs, you can destroy all the deployed Azure resources when you are finished.

From your **local machine's `infra` directory**:

```bash
terraform destroy -auto-approve
```