README.md with:
o Instructions to deploy/destroy
o DNS endpoint for ALB (for verifying IP response)


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



Important commands:
1. terraform init
    - Initializes a Terraform working directory by downloading necessary provider plugins, setting up the backend (if configured), and       
      preparing the directory for other commands.
2. terraform fmt
    - formats documents in current directory (no changes to the code itself)
3. terraform validate
    - Validates syntax of the manifests      
4. terraform plan
    - Generates an execution plan showing what Terraform will do when you apply the changes
5. terraform apply
    - applies changes to the master node
- terraform destroy
    - destroys all infrastructure created by terraform
    - You can use the -target option to destroy a particular resource and its dependencies
