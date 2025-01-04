#!/bin/bash

# Certbot DNS-01 Challenge Configuration Generator for Kubernetes
#
# This script generates Kubernetes configurations for automatic SSL certificate
# renewal using Certbot with DNS-01 challenge via Loopia API.
#
# Usage: ./scripts/generate-k8s-config.sh

# Set script to exit on any error
set -e

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the project root directory (one level up from scripts/)
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Define paths relative to project root
TEMPLATE_DIR="${PROJECT_ROOT}/k8s/cert-manager/templates"
BASE_DIR="${PROJECT_ROOT}/k8s/cert-manager/base"

# Verify directories exist
if [[ ! -d "$TEMPLATE_DIR" ]]; then
   echo "Error: Template directory not found at: $TEMPLATE_DIR"
   exit 1
fi

if [[ ! -d "$BASE_DIR" ]]; then
   echo "Error: Base directory not found at: $BASE_DIR"
   exit 1
fi

# Verify template files exist
if [[ ! -f "${TEMPLATE_DIR}/secrets.yaml" ]]; then
   echo "Error: secrets.yaml template not found at: ${TEMPLATE_DIR}/secrets.yaml"
   exit 1
fi

if [[ ! -f "${TEMPLATE_DIR}/cronjob.yaml" ]]; then
   echo "Error: cronjob.yaml template not found at: ${TEMPLATE_DIR}/cronjob.yaml"
   exit 1
fi

# Get user input
read -p "Enter domain (e.g. example.com): " DOMAIN
read -p "Enter Let's Encrypt notification email: " EMAIL
read -p "Enter Loopia API username (e.g. user@loopiaapi): " LOOPIA_USER
read -s -p "Enter Loopia API password: " LOOPIA_PASS
echo

# Generate secrets.yaml
echo "Generating secrets.yaml..."
sed -e "s/LOOPIA_USER_PLACEHOLDER/${LOOPIA_USER}/g" \
   -e "s/LOOPIA_PASS_PLACEHOLDER/${LOOPIA_PASS}/g" \
   "${TEMPLATE_DIR}/secrets.yaml" >"${BASE_DIR}/secrets.yaml"

# Generate cronjob.yaml
echo "Generating cronjob.yaml..."
sed -e "s/DOMAIN_PLACEHOLDER/${DOMAIN}/g" \
   -e "s/EMAIL_PLACEHOLDER/${EMAIL}/g" \
   "${TEMPLATE_DIR}/cronjob.yaml" >"${BASE_DIR}/cronjob.yaml"

# Set appropriate permissions
chmod 600 "${BASE_DIR}/secrets.yaml"

echo "Configuration files generated successfully!"
echo "
Generated files:
- ${BASE_DIR}/secrets.yaml
- ${BASE_DIR}/cronjob.yaml

Next steps:
1. Review the generated configurations
2. Apply the configurations:
   kubectl apply -k k8s/cert-manager/base

Note: The secrets.yaml file contains sensitive data. Keep it secure and never commit it to git."
