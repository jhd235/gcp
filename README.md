# GCP Infrastructure as Code

This project manages Google Cloud Platform (GCP) infrastructure using Terraform. It sets up essential components for a secure and automated cloud environment.

## Project Structure

```
.
├── terraform/
│   ├── main.tf              # Main Terraform configuration
│   ├── variables.tf         # Variable definitions
│   ├── provider.tf          # Provider configuration
│   ├── backend.tf           # Remote state configuration
│   ├── terraform.tfvars     # Variable values (not committed)
│   └── modules/             # Reusable Terraform modules
│       ├── gcs/             # Google Cloud Storage module
│       ├── cloudbuild/      # Cloud Build module
│       └── secret-manager/  # Secret Manager module
└── .github/                 # GitHub Actions workflows
```

## Features

- **Google Cloud Storage (GCS) Bucket**
  - Configurable location and storage class
  - Optional versioning
  - Lifecycle management
  - Secure access controls

- **Cloud Build Pipeline**
  - Automated CI/CD pipeline
  - GitHub integration
  - Main branch deployment
  - Secure credential management

- **Secret Manager Integration**
  - Secure storage of service account credentials
  - Access control management
  - Secret versioning

## Prerequisites

- Google Cloud Platform account
- Terraform (v1.0.0 or later)
- GitHub account
- Google Cloud SDK
- Required permissions in GCP project

## Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd gcp
   ```

2. Configure Google Cloud credentials:
   ```bash
   gcloud auth application-default login
   ```

3. Create a `terraform.tfvars` file with the following variables:
   ```hcl
   project_id = "your-project-id"
   project_number = "your-project-number"
   bucket_name = "your-unique-bucket-name"
   github_owner = "your-github-username"
   github_repo = "your-repository-name"
   trigger_name = "your-trigger-name"
   ```

4. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

5. Apply the configuration:
   ```bash
   terraform plan
   terraform apply
   ```

## Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `bucket_name` | GCS bucket name (globally unique) | string | - |
| `location` | Bucket location | string | "US" |
| `storage_class` | Bucket storage class | string | "STANDARD" |
| `versioning_enabled` | Enable bucket versioning | bool | false |
| `lifecycle_age` | Days to retain files | number | 30 |
| `force_destroy` | Force bucket deletion | bool | false |
| `project_id` | GCP project ID | string | - |
| `project_number` | GCP project number | string | - |
| `github_owner` | GitHub repository owner | string | - |
| `github_repo` | GitHub repository name | string | - |
| `trigger_name` | Cloud Build trigger name | string | - |

## Security

- Service account credentials are stored in Secret Manager
- IAM roles are configured with least privilege principle
- Remote state is stored in a secure GCS bucket
- Sensitive variables are marked as sensitive in Terraform

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

[Add your license information here]

## Support

For support, please [create an issue](https://github.com/your-username/gcp/issues) in the repository. 