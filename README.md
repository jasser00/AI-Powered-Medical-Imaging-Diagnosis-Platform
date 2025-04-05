# AI-Powered Medical Imaging Diagnosis Platform (AWS + Terraform)

A cloud-native solution for automating medical imaging diagnosis using AI/ML models. Built on AWS with Terraform for infrastructure-as-code (IaC), this project enables secure, HIPAA-compliant uploads of medical images (MRI, CT scans, X-rays) and provides AI-generated diagnostic reports with real-time notifications.


*Diagram created with [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)*

![myfinalproject drawio](https://github.com/user-attachments/assets/9a07e173-de90-448e-a52d-f42658a42f46)



## Features
- **Secure Uploads**: Presigned S3 URLs + AWS KMS encryption for medical imaging files.
- **AI/ML Processing**: Auto-scaling EC2 Spot Instances for cost-efficient model inference.
- **Serverless APIs**: Lambda + API Gateway for patient/doctor interactions.
- **Real-Time Alerts**: SNS notifications for report completion.
- **Compliance**: HIPAA/GDPR-ready (encryption, WAF, IAM least privilege).

## Tech Stack
| Category          | Tools/Services                                                                 |
|-------------------|--------------------------------------------------------------------------------|
| **Cloud**         | AWS (S3, CloudFront, Lambda, EC2, DynamoDB, SQS, SNS, API Gateway, KMS, WAF)  |
| **IaC**           | Terraform (v1.5+), S3 (remote backend)                            |
| **Security**      | AWS KMS, IAM Roles, HTTPS (ACM), WAF (OWASP Top 10 rules)                      |
                          

## Prerequisites
1. **AWS Account** with IAM permissions for listed services.
2. **Terraform** v1.5+ installed ([guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)).
3. **AWS CLI** configured with credentials (`aws configure`).
4. **Git** for version control.

## Installation & Setup

#### 1. Configure AWS Credentials
Configure AWS CLI with your credentials:
```bash
aws configure

#### 2. Initialize Terraform
Downloads required providers and modules:
```bash
terraform init

#### 3. Configure Variables
Edit terraform.tfvars:

#### 4. Apply Infrastructure Configuration
Review changes and confirm with yes:
```bash
terraform apply



5. Verify Resources
Check AWS Console for:

S3 Buckets (static content & medical images)

CloudFront Distribution

Lambda/API Gateway services

EC2 Spot Instances (Auto Scaling Group)

SNS/SQS event pipeline


🔒 Security Measures
IAM Policies: Least-privilege principle enforced

Data Encryption:

At-rest & in-transit encryption (S3/EC2)

KMS for sensitive data

Monitoring:

CloudWatch for resource logging

CloudTrail for API call auditing

