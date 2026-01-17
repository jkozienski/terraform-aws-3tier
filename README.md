# Automation of Deployment and Configuration of a Web Application Environment on the AWS Platform  
### Terraform & Ansible – Infrastructure as Code / Configuration as Code

## Abstract

The aim of this thesis was to design and implement an **automated process for deploying a web application environment in the Amazon Web Services (AWS) cloud**, covering both infrastructure provisioning and application environment configuration. The developed solution constitutes a **parameterized infrastructure template**, enabling fast, repeatable, and consistent deployment of application environments without the need for manual resource configuration.

As part of the project, **Terraform** was used to implement the *Infrastructure as Code (IaC)* approach, responsible for the automated creation of the network layer, security mechanisms, and key cloud infrastructure components such as:

- Virtual Private Cloud (VPC),
- Security Groups,
- Application Load Balancer (ALB),
- Auto Scaling Groups (ASG),
- the **Amazon RDS** relational database.

The configuration of Amazon EC2 instances was carried out using **Ansible**, implementing the *Configuration as Code (CaC)* approach. Ansible was responsible for installing the required services, deploying the application code, and configuring frontend and backend servers in a fully automated manner.

As part of the project, a **sample web application** was deployed to verify the correct operation of the designed infrastructure and the entire automated deployment process. The obtained results confirmed the effectiveness of the adopted approach and demonstrated its applicability as a universal deployment template for web applications in a cloud environment.

## Technologies Used

- **Amazon Web Services (AWS)**
- **Terraform** – Infrastructure as Code
- **Ansible** – Configuration as Code
- **EC2, ALB, ASG, RDS, VPC**
- **Linux (Ubuntu)**

## How to Run the Project

To deploy the infrastructure, navigate to the directory corresponding to the target environment:

```bash
cd ./envs/prod/
```

or

```bash
cd ./envs/dev/
```

### Initialize Terraform

Initialize the Terraform working directory:

```bash
terraform init
```

### First Run (Domain Delegation)

If this is the first run, execute Terraform with the option that displays the DNS name servers required for domain delegation:

```bash
terraform apply -var=show_nameservers=true
```

This command creates a public DNS hosted zone in **Amazon Route53** and outputs a list of name servers.  
Copy these values and configure them at your domain registrar by replacing the existing name servers.

> This step is required only once.

### Subsequent Runs / Infrastructure Updates

For all subsequent executions, or when updating the infrastructure configuration, run:

```bash
terraform apply
```
