# Terraform Modules Documentation

This document describes the interfaces and usage of the Terraform modules in this project.

## Module Structure

```
modules/
├── gcs/              # Google Cloud Storage module
├── cloudbuild/       # Cloud Build module
└── secret-manager/   # Secret Manager module
```

## GCS Module

The GCS module creates and manages Google Cloud Storage buckets.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `bucket_name` | Name of the bucket | string | - | yes |
| `location` | Bucket location | string | "US" | no |
| `storage_class` | Storage class | string | "STANDARD" | no |
| `versioning_enabled` | Enable versioning | bool | false | no |
| `lifecycle_age` | Days to retain files | number | 30 | no |
| `force_destroy` | Force destroy bucket | bool | false | no |
| `project_id` | GCP project ID | string | - | yes |
| `environment` | Environment name | string | "dev" | no |

### Outputs

| Name | Description |
|------|-------------|
| `bucket_name` | Name of the created bucket |
| `bucket_url` | URL of the created bucket |

### Example Usage

```hcl
module "gcs" {
  source = "./modules/gcs"

  bucket_name        = "my-bucket"
  location           = "US"
  storage_class      = "STANDARD"
  versioning_enabled = true
  lifecycle_age      = 30
  force_destroy      = false
  project_id         = "my-project"
  environment        = "prod"
}
```

## Cloud Build Module

The Cloud Build module sets up a CI/CD pipeline with GitHub integration.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `trigger_name` | Name of the trigger | string | - | yes |
| `project_id` | GCP project ID | string | - | yes |
| `project_number` | GCP project number | string | - | yes |
| `github_owner` | GitHub owner | string | - | yes |
| `github_repo` | GitHub repository | string | - | yes |
| `branch_pattern` | Branch pattern | string | "^main$" | no |
| `environment` | Environment name | string | "dev" | no |

### Outputs

| Name | Description |
|------|-------------|
| `trigger_id` | ID of the created trigger |
| `trigger_name` | Name of the created trigger |

### Example Usage

```hcl
module "cloudbuild" {
  source = "./modules/cloudbuild"

  trigger_name   = "my-trigger"
  project_id     = "my-project"
  project_number = "123456789012"
  github_owner   = "my-org"
  github_repo    = "my-repo"
  branch_pattern = "^main$"
  environment    = "prod"
}
```

## Secret Manager Module

The Secret Manager module securely stores and manages secrets.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `service_account_key_json` | Service account key JSON | string | - | yes |
| `project_id` | GCP project ID | string | - | yes |
| `environment` | Environment name | string | "dev" | no |

### Outputs

| Name | Description |
|------|-------------|
| `secret_id` | ID of the created secret |
| `secret_version` | Version of the created secret |

### Example Usage

```hcl
module "secret_manager" {
  source = "./modules/secret-manager"

  service_account_key_json = var.google_credentials
  project_id              = "my-project"
  environment            = "prod"
}
```

## Module Dependencies

- GCS module requires:
  - Google Cloud Storage API enabled
  - Appropriate IAM permissions
  - Valid project ID

- Cloud Build module requires:
  - Cloud Build API enabled
  - GitHub repository access
  - Valid project ID and number
  - Appropriate IAM permissions

- Secret Manager module requires:
  - Secret Manager API enabled
  - Valid service account key
  - Appropriate IAM permissions

## Versioning

Each module should be versioned using Git tags. Example:

```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

## Testing

Each module should include:
1. Input validation
2. Output verification
3. Integration tests
4. Security scanning

Example test structure:
```
modules/
└── gcs/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── tests/
        ├── test_gcs.tf
        └── test_gcs.sh
```

## Security Considerations

1. All sensitive inputs should be marked as `sensitive = true`
2. IAM roles should follow least privilege principle
3. Regular security audits should be performed
4. Secrets should never be committed to version control
5. All API calls should be encrypted

## Maintenance

1. Regular updates to provider versions
2. Security patches
3. Documentation updates
4. Test coverage improvements
5. Performance optimizations 