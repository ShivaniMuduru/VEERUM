# VEERUM AWS S3 bucket Replication
​
## Veerum Technical challenge 
* S3 buckets in multi region with *2 cross replication
* Using automation tool Jenkins to provision AWS resource
​
## Prerequisites
This project has acted as terraform version 0.12.26. Before you can run the test you must make sure you have right version 
​
| Resource                       | Terraform version             
|--------------------------------|--------------------|
| S3 bucket                      |        0.12.26      |
​
## Install Terraform
​
```
wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip -O terraform.zip
unzip terraform.zip
rm terraform.zip
sudo mv terraform /usr/local/bin/terraform
```
​
## Getting Started  
​
1. Create the terraform.tfvars file with the credentials to access AWS 
2. Run ``` terraform init ```
3. Run ``` terraform plan ```
4. Run ``` terraform apply ```
​
### Provisioning from CICD Pipeline using Jenkins
​
#### 
Update the Jenkins git credential to checkout the source code and run a new job to provision the resource using ``` JENKINSFILE ``` script
