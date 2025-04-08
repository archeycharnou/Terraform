🎯 Objective
Provision a secure, highly available AWS environment that includes a: VPC, EC2 instances behind
a Load Balancer and Auto Scaling Group, a MySQL RDS instance, and S3 bucket for private
document storage. Enable monitoring and auditing via CloudWatch and CloudTrail.
When the system is accessed via port 80, it should respond with the instance’s public IP
address in plain text.
Our expectation is to see a live demo that satisfies this objective.

⚙ Expected Deliverables
1. Infrastructure Code (Terraform, CloudFormation, or AWS CDK)
2. README.md with:
o Instructions to deploy/destroy
o DNS endpoint for ALB (for verifying IP response)
3. (Optional) Public git repo with code and markdown documentation

💡 Notes
• You may use Terraform, CloudFormation, or AWS CDK
• Keep everything inside a single AWS region (e.g., us-east-1)
• Aim for free-tier resources where possible


###################
IMPORTANT COMMANDS
###################

** Terraform & AWS CLI should be installed

1. terraform init (-upgrade flag to use the most recent provider version)
    - Initializes a Terraform working directory by downloading necessary provider plugins, setting up the backend (if configured), and       
      preparing the directory for other commands.

2. terraform fmt
    - formats documents in current directory (no changes to the code itself)
3. terraform validate
    - Validates syntax of the manifests 

4. terraform plan
    - Generates an execution plan showing what Terraform will do when you apply the changes
    - use -out=plan.txt
    - use the -target flag with your plan, apply and destroy commnands to limit api usage with large infra
        terraform plan -target <resource>.<resource_name>
        terraform plan -target="<resource>.<resource_name>"     # If above doesnt work

5. terraform apply
    - applies changes to the master node
    - Apply must be ran again after uncommenting the backend remote state connection

6. terraform destroy
    - destroys all infrastructure created by terraform
    - You can use the -target option to destroy a particular resource and its dependencies


###################
DEBUGGING
###################
Debugging can provide detailed logs of terraform operations by setting the TF_LOG environment variable to values:

TRACE - most verbose
DEBUG
INFO
WARN
ERROR

in terminal:
export TF_LOG=<value> (LINUX)
set TF_LOG=<value> (WINDOWS)

SET and EXPORT will only last for the session

Can also set a TF_LOG_PATH to output to specific file
export TF_LOG_PATH=<value> (LINUX)
set TF_LOG_PATH=terraform.log (WINDOWS)

