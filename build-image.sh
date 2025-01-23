#!/bin/bash

# Parameters
IMAGE_BUILDER_NAME="automated-appstream"
INSTANCE_TYPE="stream.standard.large"
BASE_IMAGE_NAME="AppStream-WinServer2016-10-22-2024 (Public)"
IAM_ROLE_ARN="arn:aws:iam::690797694046:role/appseteam-automation"
#DIRECTORY_NAME="godingreen1.com"
#OU_DISTINGUISHED_NAME="OU=AWS Reserved,DC=godingreen1,DC=com"

# Step 1: Create Image Builder
aws appstream create-image-builder \
  --name "$IMAGE_BUILDER_NAME" \
  --instance-type "$INSTANCE_TYPE" \
  --image-name "$BASE_IMAGE_NAME" \
  --iam-role-arn "$IAM_ROLE_ARN" \
  #--domain-join-info "{\"DirectoryName\":\"$DIRECTORY_NAME\",\"OrganizationalUnitDistinguishedName\":\"$OU_DISTINGUISHED_NAME\"}"

# Wait for the image builder to become available
echo "Waiting for Image Builder to become available..."
aws appstream wait image-builder-running --name "$IMAGE_BUILDER_NAME"

# Step 2: Create Custom Image
CUSTOM_IMAGE_NAME="god-appstream-$(date +%Y%m%d%H%M%S)"
aws appstream create-image \
  --name "$CUSTOM_IMAGE_NAME" \
  --image-builder-name "$IMAGE_BUILDER_NAME"

echo "Custom Image creation initiated: $CUSTOM_IMAGE_NAME"
