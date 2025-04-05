# AI-Powered Medical Imaging Diagnosis Platform (AWS + Terraform)

A cloud-native solution for automating medical imaging diagnosis using AI/ML models. Built on AWS with Terraform for infrastructure-as-code (IaC), this project enables secure, HIPAA-compliant uploads of medical images (MRI, CT scans, X-rays) and provides AI-generated diagnostic reports with real-time notifications.

![Architecture Diagram](./docs/architecture.png)  
*Diagram created with [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)*



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

### 1. Clone Repository
```bash
git clone https://github.com/your-username/aws-medical-imaging-platform.git
cd aws-medical-imaging-platform
