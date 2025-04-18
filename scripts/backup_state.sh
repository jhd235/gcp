#!/bin/bash

# Script to backup Terraform state
# Usage: ./backup_state.sh <environment>

set -euo pipefail

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to validate input
validate_input() {
    if [[ ! "$1" =~ ^(dev|staging|prod)$ ]]; then
        handle_error "Invalid environment. Must be one of: dev, staging, prod"
    fi
}

# Function to check dependencies
check_dependencies() {
    local dependencies=("terraform" "gzip" "aws" "gsutil")
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            handle_error "$cmd is required but not installed"
        fi
    done
}

# Function to get remote state configuration
get_remote_state_config() {
    local backend_type
    backend_type=$(terraform output -raw backend_type 2>/dev/null || echo "local")
    echo "$backend_type"
}

# Function to pull remote state
pull_remote_state() {
    local backend_type=$1
    case "$backend_type" in
        "s3")
            aws s3 cp "s3://${BUCKET_NAME}/terraform.tfstate" "${STATE_FILE}" || handle_error "Failed to pull state from S3"
            ;;
        "gcs")
            gsutil cp "gs://${BUCKET_NAME}/terraform.tfstate" "${STATE_FILE}" || handle_error "Failed to pull state from GCS"
            ;;
        "local")
            cp "terraform.tfstate" "${STATE_FILE}" || handle_error "Failed to copy local state"
            ;;
        *)
            handle_error "Unsupported backend type: $backend_type"
            ;;
    esac
}

# Function to push remote state
push_remote_state() {
    local backend_type=$1
    case "$backend_type" in
        "s3")
            aws s3 cp "${BACKUP_FILE}.gz" "s3://${BUCKET_NAME}/backups/${BACKUP_FILE_NAME}.gz" || handle_error "Failed to push backup to S3"
            ;;
        "gcs")
            gsutil cp "${BACKUP_FILE}.gz" "gs://${BUCKET_NAME}/backups/${BACKUP_FILE_NAME}.gz" || handle_error "Failed to push backup to GCS"
            ;;
        "local")
            cp "${BACKUP_FILE}.gz" "${BACKUP_DIR}/${BACKUP_FILE_NAME}.gz" || handle_error "Failed to copy backup"
            ;;
    esac
}

# Main script
ENVIRONMENT=${1:-dev}
validate_input "$ENVIRONMENT"
check_dependencies

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="terraform/state_backups"
STATE_FILE="terraform.tfstate"
BACKUP_FILE_NAME="${ENVIRONMENT}_${TIMESTAMP}.tfstate"
BACKUP_FILE="${BACKUP_DIR}/${BACKUP_FILE_NAME}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Check if Terraform is initialized
if [ ! -d "terraform/.terraform" ]; then
    handle_error "Terraform not initialized. Run 'terraform init' first"
fi

# Get remote state configuration
BACKEND_TYPE=$(get_remote_state_config)

# Pull current state
echo "Pulling current Terraform state..."
pull_remote_state "$BACKEND_TYPE"

# Create backup
echo "Creating backup at ${BACKUP_FILE}..."
cp "${STATE_FILE}" "${BACKUP_FILE}"

# Compress backup
echo "Compressing backup..."
gzip "${BACKUP_FILE}"

# Push backup to remote storage
echo "Pushing backup to remote storage..."
push_remote_state "$BACKEND_TYPE"

# Clean up old backups (keep last 5)
echo "Cleaning up old backups..."
case "$BACKEND_TYPE" in
    "s3")
        aws s3 ls "s3://${BUCKET_NAME}/backups/" | sort -r | tail -n +6 | awk '{print $4}' | xargs -I {} aws s3 rm "s3://${BUCKET_NAME}/backups/{}"
        ;;
    "gcs")
        gsutil ls "gs://${BUCKET_NAME}/backups/" | sort -r | tail -n +6 | xargs -I {} gsutil rm {}
        ;;
    "local")
        ls -t "${BACKUP_DIR}"/*.tfstate.gz | tail -n +6 | xargs rm -f
        ;;
esac

# Verify backup
if [ -f "${BACKUP_FILE}.gz" ]; then
    echo "Backup created successfully: ${BACKUP_FILE}.gz"
    echo "Backup size: $(du -h "${BACKUP_FILE}.gz" | cut -f1)"
else
    handle_error "Backup creation failed"
fi

# Clean up temporary state file
rm -f "${STATE_FILE}"

echo "Backup completed successfully" 