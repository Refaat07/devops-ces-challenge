# Datavisyn DevOps CES Challenge

# Architecture Overview
For this submission of the DevOps CES challenge, the used tech stack is as follows:
- **Identity Provider:** Google
- **Cloud Provider:** AWS
- **Kubernetes Cluster:** EKS (Elastic Kubernetes Service)
- **Authentication method:** Application Load Balancer authentication using OIDC (OpenID Connect)
- **Package Management:** Helm charts
- **Continuous Deployment:** ArgoCD
- **CD Authentication**: Google - ArgoCD built in SSO using Dex

# Architecture Diagram
This is a high-level architecture diagram, showing the components and services used, as well as user and admin/dev team traffic flows.
![Architecture Diagram](/Images/datavisyn-architecture-diagram.drawio.png)

Next is a walkthrough of the components used in this solution.
# Architecture walkthrough
## Infrastructure

### Kubernetes & Compute
- The EKS Cluster Node pool consists of an autoscaling group of two nodes at base, with the possibility of scaling up to three nodes, or down to one.
- The Cluter consists of two namespaces:
  - The `default` namespace for the application deployments.
  - The `argocd` namespace for ArgoCD resources.
- Helm charts are used throughout the cluster for easier package management for the application and ArgoCD.
- ArgoCD is installed in the cluster via a Helm chart deployed through Terraform.
- The application manifest is then also applied through Terraform, which instructs ArgoCD to deploy the application and its required services using a Helm chart of its own, found in the repository.
- The ArgoCD Helm chart has added properties for Dex Authentication with Google as well as the domain name for the ArgoCD server. The `values.yaml` file in the `terraform/modules/helm` directory contains the configuration as well as detailed documentation for further customization.

### Networking
- The VPC consists of a public and a private subnet. The public subnet contains the NAT gateway and the Internet gateway, while the private subnet contains the compute resources, which are the EKS worker nodes in our case.
- Route tables are defined for the private subnet to allow outbount internet traffic through the NAT gateway, allowing our applications to communicate with the required services such as GitHub for pulling application images.
- Two Application Load Balancers are defined for controlled ingress to the applications:
  - One ALB for the backend application, with OIDC authentication functionality.
  - One ALB for the ArgoCD server, with no authentication functionality as that is handled by the ArgoCD server.
- Both ALBs have listeners that use the ACM certificates to receive HTTPS traffic on the corresponding domains.
- TLS termination is handled by the ALB listeners for architectural simplicity and to offload cryptographic processing from cluster resources. HTTP traffic is then routed to the appropriate resources through private connectivity.

### Automation: Terraform
The entire infrastructure is provisioned and managed with Terraform.
Under the Terraform directory, the following resources are provisioned:
- **The `vpc` module:**
  - The VPC
  - A public and private subnet
  - A NAT Gateway
  - An Internet Gateway
  - Security Groups for worker nodes
  - Route tables & associations

- **The `eks` module:**
  - The EKS cluster
  - Worker Nodes
  - An Application Load Balancer
  - An ALB listener where OIDC authentication with Google Oauth takes place
  - A target group for the ALB listener
  - The required IAM permissions for operation

- **The `helm_charts` module:**
  - A helm chart for ArgoCD
  - A Kubernetes manifest for the backend application, deployed through ArgoCD
  - An Application Load Balancer for ingress to the ArgoCD server

Explicit dependencies are defined where necessary to ensure smooth end to end runs of `terraform apply`

#### Secret management in Terraform
Secrets and SSL certificates are never stored in code. Instead, they are retrieved in runtime via data sources defined in the `data.tf` file and are covered in variables with the `sensitive=true` attribute to prevent them showing in any provisioning logs.


### Authentication flow
- **Application**
  - A user visits the domain https://example.com
  - The Application Load Balancer intercepts the request
  - If the user is unauthenticated, they are redirected to Google to authenticate.
  ![User Login to Google, prompted by ALB OIDC](/Images/user-auth-app.jpg)
  - After the user signs in to Google, if this is the first time the users authenticates to the application, they are prompted to accept the data that the application receives about them, in this case the profile and email.
  - The user is then sent back to the application as an authenticated user, where they will be greeted with the application's homepage.
  - If the user is authenticated, the request goes through to the application. The user goes directly the application homepage.
  ![Successful login, the user is redirected back to the app](/Images/user-auth-success.jpg)
 
- **ArgoCD Server**
  - A user visits the ArgoCd domain https://argocd.example.com
  - The Application Load Balancer routes the request to the ArgoCD server, where the user sees a login screen.
  - The user has the option to sign in with Google.
  ![ArgoCD login page with Sign in with Google option](/Images/argo-oidc-login.jpg)
  -  After the user signs in to Google, if this is the first time the users authenticates to the application, they are prompted to accept the data that the application receives about them, in this case the profile and email.
  - The user then is logged into ArgoCD server, and can see applications and perform actions according to the roles provided to them in the ArgoCD configmap, defined within the `values.yaml` file.
  ![ArgoCD homepage after successful login](/Images/argo-oidc-login-success.jpg)
  
  >**Note:** The default role for the ArgoCD server is `readonly`. However, if the user is granted an admin role, they can see all the deployed applications as well as make changes.


# Setup and implementation

## Prerequisites
- **A domain name** from any domain registrar (e.g [GoDaddy](https://godaddy.com)).
- **An AWS Account** with sufficient IAM privileges to perform operations on networking, EKS, secrets, storage and certificates.
- **Software and CLI tools**
  - Terraform
  - AWS CLI
  - Kubectl
  - Helm
  - ArgoCD CLI
  - Python

## Oauth
### Provider: Google
Google is our Identity Provider of choice, as it is fully compatible with OIDC, which is the authentication method we are using for this project.
To start off, we begin by creating our Oauth app from the Google Cloud Console under Google Oauth Platform. 

#### Create a new Oauth application
- Go to [the Google Cloud Console](https://console.cloud.google.com/) and search for Google Oauth Platform in the search bar.
- Select **Clients** from the menu on the left.
- Click on **Create Client**.
- Select **Web Application** from the dropdown menu.
- Give your application a name and fill out the information as follows:
- **Authorized Javascrip origins**: Enter the domain name you wish for your application to be accessible on.

Make sure that the Authorized Javascript Origins match the domains we wish to access our applications on, and the authorized Redirect URIs match the following format:

- **Application**: https://your.example.com/oauth2/idpresponse 
  *The format recognized by the Application Load Balancer OIDC authentication.*
- **ArgoCD Server**: https://your.argo-example.com/api/dex/callback
  *The format recognized by the Dex connector which ArgoCD uses.*

  ![Example ArgoCD Oauth App](/Images/argo-oauth-app.jpg)

>**Note:**
Using Google as an Oauth provider allows for multiple origin domains and multiple callback/redirect URIs, meaning that we can use the same Oauth client for both our application and ArgoCD server. However, in this solution, I have opted to use separate apps for the possibility of more granular access control over either application.

## Cloud Provider: AWS

### Setting up the environment

### Setting up AWS CLI
Authenticating with AWS CLI will allow Terraform and other tools to perform operations on the AWS account we are signed in. To authenticate with AWS CLI, first you will need an access key ID and a secret access key, which you can create for your account and obtain from the AWS console.
Make sure that you have the correct IAM permissions that will allow you to perform the required actions. Once you have the access key ID and the secret access key, the easiest way to authenticate is to insert them in your AWS credentials file as follows:
- Create the file `~/.aws/credentials` and open it using uour preferred text editor.
- Add the information as follows:
```
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
region = eu-central-1
```
>**Note:** The default region for this project is `eu-central-1` (Frankfurt), but it can be overriden by Terraform's `.tfvars` file. more on that below.

### Set secrets in AWS Secrets Manager
Once you are authenticated to AWS CLI, it is time to start adding secrets and other sensitive data that will be used in the implementation.
Make sure that the identity (user or role) used to create the secrets in AWS Secrets Manager has the required permissions granted by the `SecretsManagerReadWrite` managed policy.

The secrets we will need to add to Secrets Manager are the Oauth2 Client secrets. Run this command once for the application `google_client_secret` and once for `argocd_client_secret`.

```bash
aws secretsmanager create-secret --name google_client_secret --secret-string <SECRET_VALUE>
aws secretsmanager create-secret --name argocd_client_secret --secret-string <SECRET_VALUE>
```
### Request certificates for Application Load Balancers
To request SSL certificates from AWS Certificates Manager, run the following command:

``` bash
aws acm request-certificate --domain-name www.example.com --validation-method DNS
```
If the domains for your applciation and your ArgoCD server are under the same apex domain, you can request one certificate that covers the apex domain and all its subdomains:

```bash
aws acm request-certificate --domain-name example.com --subject-alternative-names *.example.com --validation-method DNS
```
Once certificates have been requested, they will be in a pending state until you complete the DNS challenge, proving ownership of your domain. You will need to add a CNAME DNS entry with your registrar that matches the one issued by AWS.
Go to the AWS Console > AWS Certificate Manager.
![List of Certificates in ACM](/Images/cert-list.jpg)

Find the certificate you requested for your domain and open it.

![Certificate Challenge, example values ommitted.](/Images/cert-challenge.jpg)

Copy the entry provided, go to your domain settings in your registrat and paste it as a CNAME record.

![Adding a CNAME entry for the DNS challenge](/Images/cert-challenge-entry.jpg)

After some time, the certificate state will change to `ISSUED`.

>**Note:** ACM certificates will continue to be renewed automatically as long as you keep the CNAME record for the challenge in your DNS settings and you are using the certificate with AWS resources, which is the case in this implementaion.

### Create S3 bucket for Terraform state
An S3 bucket should be created, ideally with versioning enabled in order to store the Terraform state in, and have backups stored in it. You can use the following command to create an S3 bucket. Make sure that the name is globally unique.

```bash
aws s3 mb s3://<BUCKET_NAME> --region <YOUR_REGION>
```

## Provision the infrastructure with Terraform

To provision the infrastructure, first clone the repository:

```bash
git clone https://github.com/Refaat07/devops-ces-challenge
```
Then go to the `terraform/` directory and initialize the Terraform environment.

```bash
terraform init
```

take note of the files in the root module. If you do not want to use default values for your infrastructure (e.g to override domain names with your own), take note of the `variables.tf` file, and construct your `terraform.tfvars` file with key-value pairs matching the entries in `variables.tf`. Once ready, run:
```bash
terraform apply
```
Review the infrastructure to be deployed, then type `yes` and press enter.

## Add CNAME records for the provisioned ALBs
The final step is to bind your subdomains to the Application Load Balancers, which already have the SSL certificates for their respective domain names. To do that, run the following command to get a list of your ALBs:
```bash
aws elbv2 describe-load-balancers \
    --query "LoadBalancers[?Type=='application'].[LoadBalancerName, DNSName]" \
    --output table
```
The output for this command will be a table that looks similar to this:
```
------------------------------------------------------------------------
|                         DescribeLoadBalancers                        |
+------------+---------------------------------------------------------+
|  dv-eks-alb|  dv-eks-alb-1476219842.eu-central-1.elb.amazonaws.com   |
|  argocd-alb|  argocd-alb-446750720.eu-central-1.elb.amazonaws.com    |
+------------+---------------------------------------------------------+
```

Find the Load Balancers with the corresponding names to the ones created through Terraform for this infrastructure, and add their DNS names to the corresponding subdomains as CNAME entries with your domain registrar.

![ALB CNAME DNS entry](/Images/alb-dns-entry.jpg)

Wait for some time (might take up to a few hours) for DNS propagation to complete. After that your users can access your application on the specified domain, and your team can access your ArgoCD server at its specified domain.

## Rotate Oauth secrets
It is recommended to set up a fixed rotation period for your secrets, or at least a reminder to rotate them. 
To rotate your client secrets, first go to your Oauth app, then click on **Add new Secret**. Google will immediately issue a new client secret for your Oauth application.

![New Oauth app secret](/Images/new-secret.jpg)

Click **Disable** on the old secret, then download or copy the new secret.Once you have the new secret string, you can rotate the secret using this command:
```bash
aws secretsmanager put-secret-value \
    --secret-id MyCustomSecret \
    --secret-string <NEW_SECRET_STRING>
```

# PoC
The application is currently accessible for the duration of the hiring process.
application: https://dvtask.mrefaat.me
ArgoCD server: https://argocd.mrefaat.me