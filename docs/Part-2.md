# Part 2. Infrastructure As Code (~30-45 mins)

> Infrastructure as code (IaC) is the process of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools. The IT infrastructure managed by this process comprises both physical equipment, such as bare-metal servers, as well as virtual machines, and associated configuration resources. The definitions may be in a version control system. The code in the definition files may use either scripts or declarative definitions, rather than maintaining the code through manual processes, but IaC more often employs declarative approaches. 

From [Wikipedia](https://en.wikipedia.org/wiki/Infrastructure_as_code)

In other word : it's easier to manage your infrastructure (physical or virtual components) with code in particular combined with Git.

In this part we will use [Terraform](https://www.terraform.io/) from [Hashicorp](https://www.hashicorp.com/), which is the most popular tool for IaC, to deploy the infrastructure needed for our Web Application.

**🏆 Objective:** Deploy the infrastructure needed to deploy our application

**⚙️ Exercice 1:** Configure and deploy the network

- [ ] If you don't have already install **[Terraform, it's time to do it](https://learn.hashicorp.com/tutorials/terraform/install-cli)**
- [ ] We are going to deploy the network layer
- [ ] The code is provided inside the related directory 
- [ ] The file `01-locals.tf` contains the configuration that you need to provide to be able to deploy the network layer
- [ ] Complete the variables with `FIX_ME` value. For the CIDR provide a `/20` private CIDR.
- [ ] We need to initialize your terraform configuration with the `init` command. Initialization will download all dependencies.
- [ ] Run terraform with the `plan` command to look at what terraform will do (and catch errors ^^)
- [ ] Run terraform with the `apply` command to create the network part on AWS
- [ ] Once terraform applied, look at the resources created on AWS

Network is deployed. Let's move to the next exercice to deploy EKS related things.

<details>
<summary>Hint 1</summary>
Example CIDR: 10.10.0.0/20
</details>

<details>
<summary>Hint 2</summary>
To run a `init` with Terraform : `terraform init`
</details>

<details>
<summary>Hint 3</summary>
To run a `plan` with Terraform : `terraform plan`
</details>

<details>
<summary>Hint 4</summary>
To run a `apply` with Terraform : `terraform apply`
</details>

<details>
<summary>Hint 5</summary>
It's always a good practice to check what Terraform will do with the plan command before applying. That's allow you to understand the changes that you are going to do. Even if the `apply` command will show you the changes, it's highly recommanded to plan before (to avoid quick answer to the question in the apply without reviewing your changes).
</details>

<details>
<summary>Hint 6</summary>
You can check your VPC and subnets with the AWS CLI: 

```
aws ec2 describe-vpcs
aws ec2 describe-subnets
```

You could also see all the changes with the [AWS Web Console](https://eu-west-3.console.aws.amazon.com/vpc/home?region=eu-west-3#).
</details>

---

**⚙️ Exercice 2:** Configure and deploy Elastic Kubernetes Service (EKS)

- [ ] Now, we will deploy the Kubernetes cluster that will support our application. We will use a managed service called EKS that allow us to easily deploy (and maintain) a Kubernetes cluster
- [ ] Rename the file `02-eks.tbd` in `02-eks.tf` to instruct Terraform to execute the instruction in this file
- [ ] Uncomment the section related to EKS in the file `01-locals.tf`
- [ ] Since we added new code to our terraform codebase, run again the `init -upgrade` command to ensure that all dependencies are update to date 
- [ ] Like in the previous exercice, check the changes before the apply
- [ ] You can look at the creation of the cluster through the [AWS Console](https://eu-west-3.console.aws.amazon.com/eks/home?region=eu-west-3). This operation take a few minutes (~ > 15 mins)
- [ ] During the creation of EKS ... TB COMPLETED
- [ ] Your EKS cluster is UP and RUNNING
- [ ] You can manage your Kubernetes cluster with `kubectl`. If you don't have already install it, [it's time to do it](https://kubernetes.io/docs/tasks/tools/)**
- [ ] Before using `kubectl` you have to configure your environement to point to your EKS cluster. Use the AWS CLI to do that with the `aws eks update-kubeconfig` command
- [ ] Now you can look at the pods running in your cluster : `kubectl get pods -A`

Your EKS is fully operational. Move to the next exercice to deploy a private Docker Registry with ECR for our application images.

<details>
<summary>Hint 1</summary>
To run a `plan` with Terraform : `terraform plan`
</details>

<details>
<summary>Hint 2</summary>
To run a `init` with Terraform : `terraform init`
To run a `plan` with Terraform : `terraform plan`
To run a `apply` with Terraform : `terraform apply`
</details>

<details>
<summary>Hint 3</summary>
To configure your kubectl environment with your cluster: run the following command : 

```
aws eks update-kubeconfig --name REPLACE_WITH_YOUR_CLUSTER_NAME --region eu-west-3
```
</details>

<details>
<summary>Hint 4</summary>
To find your running pods:
```
kubectl get pods -A # -A mean on all namespace
```
</details>

**⚙️ Exercice 3:** Deploy a private Docker registry

- [ ] We are going to deploy a private Docker registry (ECR - Amazon Container Registry) 
- [ ] ECR will be use to store the image of our application
- [ ] Will will also create some resources for our Gitlab Runner that will allow it to use ECR
- [ ] Rename the file `03-ecr.tbd` in `03-ecr.tf` to instruct Terraform to execute the instruction in this file
- [ ] Check what terraform will demo
- [ ] Fix the error by setting in `01-locals.tf` the correct variable named `app`. Use a map of map named `ecr`, with a key/value : `name: dojo-padok-${local.owner}`
- [ ] Like previous exercices, ensure that terraform has all dependencies available, review the change that terraform will apply and them, apply
- [ ] Them apply your change with terraform
- [ ] Use AWS CLI or the AWS Console to check your repository added

Your ECR is fully operational. Move to the next exercice to finish the deployment of the infrastructure with a S3 bucket for Gitlab runner caching.

<details>
<summary>Hint 1</summary>
Code for add a repository on ECR:
```
  ecrs = {
    "app" = {
      name = "dojo-padok-${local.owner}"
    }
  }
```
</details>

<details>
<summary>Hint 2</summary>

Get the list of your repository with AWS CLI:

```
aws ecr describe-repositories
```
</details>

**⚙️ Exercice 4:** Deploy resources for your Gitlab runner: IAM permissions

- [ ] Last part for the infrastructure. We are going to deploy IAM ressources for your Gitlab Runner. Gitlab need to be able to use our ECR registry
- [ ] Rename the file `04-gitlab.tbd` in `04-gitlab.tf` to instruct Terraform to execute the instruction in this file
- [ ] Like previous exercices, review the change that terraform will apply and them, apply
- [ ] Them apply your change with terraform
- [ ] Use AWS CLI or the AWS Console to check your s3 bucket

<details>
<summary>Hint 1</summary>
Example of Gitlab caching S3 uniq name
```
padok-dojo-gitlab-caching-guillaume
```
</details>

<details>
<summary>Hint 2</summary>
Get the list of your bucket with AWS CLI:

```
aws s3api list-buckets
```
</details>

**😻 Our infrastructure is UP and RUNNING, we can move the the next part !**
