#!/bin/bash

# Certbot DNS-01 Challenge Configuration Generator for Kubernetes
# 
# This script generates Kubernetes configurations for automatic SSL certificate 
# renewal using Certbot with DNS-01 challenge via Loopia API.
#
# Prerequisites:
# - Loopia API credentials (create at https://customerzone.loopia.com/api)
# - Domain registered with Loopia
# - Valid email for Let's Encrypt notifications
#
# SECURITY NOTE:
# - Generated files contain sensitive data - keep them secure
# - Do NOT commit generated files to git
# - Files will be created in current directory:
#   - secrets.yaml (contains API credentials)
#   - cronjob.yaml (contains domain and email)

# Get user input
read -p "Enter domain (e.g. example.com): " DOMAIN
read -p "Enter Let's Encrypt notification email: " EMAIL
read -p "Enter Loopia API username: " LOOPIA_USER
read -s -p "Enter Loopia API password: " LOOPIA_PASS
echo

# Generate secrets.yaml
sed -e "s/LOOPIA_USER_PLACEHOLDER/${LOOPIA_USER}/g" \
   -e "s/LOOPIA_PASS_PLACEHOLDER/${LOOPIA_PASS}/g" \
   secrets-template.yaml > secrets.yaml

# Generate cronjob.yaml
sed -e "s/DOMAIN_PLACEHOLDER/${DOMAIN}/g" \
   -e "s/EMAIL_PLACEHOLDER/${EMAIL}/g" \
   cronjob-template.yaml > cronjob.yaml

echo "Configuration files generated successfully!"
