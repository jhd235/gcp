# GCP Infrastructure as Code

This project manages Google Cloud Platform (GCP) infrastructure using Terraform. It sets up essential components for a secure and automated cloud environment.

## Project Structure

```
.
├── terraform/
│   ├── main.tf              # Main Terraform configuration
│   ├── variables.tf         # Variable definitions with validation
│   ├── outputs.tf           # Output definitions
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
  - Tagging support

- **Cloud Build Pipeline**
  - Automated CI/CD pipeline
  - GitHub integration
  - Configurable branch patterns
  - Secure credential management
  - Environment-specific configurations

- **Secret Manager Integration**
  - Secure storage of service account credentials
  - Access control management
  - Secret versioning
  - Automatic rotation support

## Prerequisites

- Google Cloud Platform account
- Terraform (v1.0.0 or later)
- GitHub account
- Google Cloud SDK
- Required permissions in GCP project

### Version Compatibility

| Component     | Version |
|--------------|---------|
| Terraform    | >= 1.0.0|
| Google Provider| >= 4.0.0|
| GitHub       | Latest  |

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
   environment = "dev" # or "staging" or "prod"
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

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `project_id` | GCP project ID | string | - | yes |
| `project_number` | GCP project number | string | - | yes |
| `bucket_name` | GCS bucket name | string | - | yes |
| `location` | Bucket location | string | "US" | no |
| `storage_class` | Bucket storage class | string | "STANDARD" | no |
| `versioning_enabled` | Enable versioning | bool | false | no |
| `lifecycle_age` | Days to retain files | number | 30 | no |
| `force_destroy` | Force bucket deletion | bool | false | no |
| `github_owner` | GitHub owner | string | - | yes |
| `github_repo` | GitHub repository | string | - | yes |
| `trigger_name` | Cloud Build trigger | string | - | yes |
| `branch_pattern` | Branch pattern | string | "^main$" | no |
| `environment` | Environment | string | "dev" | no |
| `secret_id` | Secret ID | string | - | yes |

## Security

- Service account credentials are stored in Secret Manager
- IAM roles are configured with least privilege principle
- Remote state is stored in a secure GCS bucket
- Sensitive variables are marked as sensitive in Terraform
- All resources are tagged with environment and project information
- Input validation for all variables
- Regular security audits recommended

## State Management

- Remote state is stored in GCS bucket
- State locking is enabled by default
- Regular state backups are recommended
- State versioning is enabled
- Access to state is restricted by IAM

## Testing

1. Run Terraform validation:
   ```bash
   terraform validate
   ```

2. Run Terraform plan:
   ```bash
   terraform plan
   ```

3. Check for security issues:
   ```bash
   terraform plan -out=tfplan
   terraform show -json tfplan | checkov
   ```

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Ensure `gcloud auth application-default login` is run
   - Check service account permissions
   - Verify project ID and number

2. **State Lock Issues**
   - Check for existing locks in GCS bucket
   - Verify IAM permissions
   - Use `terraform force-unlock` if necessary

3. **Resource Creation Failures**
   - Check resource quotas
   - Verify network connectivity
   - Review error messages in GCP Console

### State Recovery

1. **Backup State**
   ```bash
   terraform state pull > state_backup.tfstate
   ```

2. **Restore State**
   ```bash
   terraform state push state_backup.tfstate
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### Development Workflow

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature
   ```

2. Make changes and commit:
   ```bash
   git add .
   git commit -m "Description of changes"
   ```

3. Push changes:
   ```bash
   git push origin feature/your-feature
   ```

4. Create Pull Request

## License

[Add your license information here]

## Support

For support, please [create an issue](https://github.com/your-username/gcp/issues) in the repository.

## Maintenance

### Regular Tasks

1. Update provider versions
2. Review and update IAM permissions
3. Rotate service account keys
4. Backup Terraform state
5. Review and update security policies

### Breaking Changes

When making breaking changes:
1. Document the changes
2. Provide migration steps
3. Update version numbers
4. Notify all users
5. Create backup before applying changes 