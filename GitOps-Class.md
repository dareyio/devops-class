## Introduction to GitOps:
GitOps is a software development and operations (DevOps) methodology that leverages Git as the single source of truth for managing infrastructure and application deployments. With GitOps, the desired state of the system is defined in Git repositories, and tools automate the process of applying those changes to the target environment.

### Why use GitOps:

- Infrastructure as Code: GitOps treats infrastructure and application configuration as code, enabling version control, collaboration, and reproducibility.
- Continuous Delivery: GitOps enables a continuous delivery workflow, where any changes committed to Git are automatically deployed to the target environment.
- Auditing and Rollbacks: Git provides an audit trail of all changes, allowing easy rollbacks to previous states if issues occur.
- Consistency and Standardization: GitOps ensures consistent and standardized deployments across different environments.

### Using GitOps with Kubernetes:
GitOps is particularly well-suited for managing Kubernetes clusters. Kubernetes resources, such as deployments, services, and configurations, can be defined in Git repositories, and GitOps tools take care of synchronizing the desired state with the actual cluster.

### Steps to use GitOps with Kubernetes:

1. Set up a Git repository: Create a Git repository to store the desired state of your Kubernetes cluster. This repository will hold the configuration files for your Kubernetes resources.
2. Define the desired state: Create YAML files for your Kubernetes resources (deployments, services, etc.) in the Git repository. Ensure that the files reflect the desired state of your cluster.
3. GitOps tool installation: Install a GitOps tool like FluxCD, which will continuously monitor the Git repository and apply changes to the Kubernetes cluster.
4. Configure GitOps tool: Connect the GitOps tool to the Git repository and provide necessary access credentials. Specify the target Kubernetes cluster for deploying changes.
5. Automation and synchronization: The GitOps tool will monitor the Git repository for changes. Any new commits or updates trigger the synchronization process, where the tool applies the changes to the Kubernetes cluster automatically.


### ArgoCD Basics

In this section, we will take a deep dive into ArgoCD, what it is, how to install, and how to deploy a basic application into it.

ArgoCD allows us to use Git as a single source of truth. This means that we define all our application configuration as code in a Git repository and ArgoCD updates our cluster to match what is defined in the repository.

In addition to watching the Git repository, it also watches the Kubernetes cluster for changes and syncs the state of the cluster back to what is defined in the Git repository if a change is detected in the cluster. Interestingly, a single ArgoCD installation can be used to manage multiple clusters as well.

Let’s install ArgoCD and take a look at it in action.

**Prerequisites**
To fully understand what will be covered in this part of the tutorial, here are the things you should set up on your computer:

- A Kubernetes cluster: We will be deploying applications to Kubernetes and as such, you need to have access to a Kubernetes cluster. For this tutorial, we will be using a tool called minikube to setup a local Kubernetes cluster for development. You can install it [here](https://minikube.sigs.k8s.io/docs/start/).
- kubectl: We need kubectl in order to run commands against our Kubernetes cluster. You can install it [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
- Helm: Helm is a package manager for Kubernetes. Later in the tutorial, we will take a look at how we can deploy helm charts with ArgoCD so you need to have it installed. Follow the steps [here](https://helm.sh/docs/intro/install/).
- Finally, you’ll need to have basic knowledge of Kubernetes and the kubectl command-line tool.


## Installation

To install ArgoCD, follow these steps:

1. Create a new namespace for ArgoCD by running the command `kubectl create namespace argocd`. This namespace will be used to group all the ArgoCD resources.

2. Install all the necessary services and applications for ArgoCD into the newly created namespace. Use the following command to do this:


To install ArgoCD, use the following `kubectl` command:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml



This command fetches the installation manifest from the official ArgoCD repository and applies it to the `argocd` namespace.

3. After running the installation command, check the status of the ArgoCD pods by executing `kubectl get pod -n argocd`. You should see the ArgoCD pods being created in your cluster. If any pods are in a Pending state, wait for a few seconds and run the command again to ensure that the pods are running before proceeding to the next step.

Now that ArgoCD is successfully installed, you can proceed to the next steps to explore its functionality.

![ArcoCD Pods](arcocd-pods.png)


## Generating ArgoCD UI Password

Now that the ArgoCD pods are up and running, we can access the ArgoCD web user interface (UI). However, before we proceed, we need to generate a password that will be used to log in to the ArgoCD UI. 

To generate the password, execute the following command:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -D; echo

Make sure you store this password securely as it will be used to gain access to your ArgoCD UI. Now, port-forward the argocd-server service to port 8080 of your local machine.

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443

![ArcoCD Server](arcocd-server-running.png)


Navigate to http://localhost:8080 in your browser and you should be greeted with a screen similar to the one below.

![ArgoCD Dashboard](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*jq8KrXOWTUs1jQhL.png)

