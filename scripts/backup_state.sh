#!/bin/bash

# Script to backup Terraform state
# Usage: ./backup_state.sh <environment>

set -e

ENVIRONMENT=${1:-dev}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="terraform/state_backups"
STATE_FILE="terraform.tfstate"
BACKUP_FILE="${BACKUP_DIR}/${ENVIRONMENT}_${TIMESTAMP}.tfstate"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Check if Terraform is initialized
if [ ! -d "terraform/.terraform" ]; then
    echo "Error: Terraform not initialized. Run 'terraform init' first."
    exit 1
fi

# Pull current state
echo "Pulling current Terraform state..."
terraform state pull > "${STATE_FILE}"

# Create backup
echo "Creating backup at ${BACKUP_FILE}..."
cp "${STATE_FILE}" "${BACKUP_FILE}"

# Compress backup
echo "Compressing backup..."
gzip "${BACKUP_FILE}"

# Clean up old backups (keep last 5)
echo "Cleaning up old backups..."
ls -t "${BACKUP_DIR}"/*.tfstate.gz | tail -n +6 | xargs rm -f

# Verify backup
if [ -f "${BACKUP_FILE}.gz" ]; then
    echo "Backup created successfully: ${BACKUP_FILE}.gz"
    echo "Backup size: $(du -h "${BACKUP_FILE}.gz" | cut -f1)"
else
    echo "Error: Backup creation failed"
    exit 1
fi

# Clean up temporary state file
rm -f "${STATE_FILE}"

echo "Backup completed successfully" 