#!/bin/bash

# Parameters
IMAGE_BUILDER_NAME="automated-appstream"
INSTANCE_TYPE="stream.standard.large"
BASE_IMAGE_NAME="AppStream-WinServer2016-06-17-2024"
IAM_ROLE_ARN="arn:aws:iam::690797694046:role/appseteam-automation"
DIRECTORY_NAME="goodin.com"
OU_DISTINGUISHED_NAME="OU=AWS Reserved,DC=goodin.com,DC=com"
VPC_ID="vpc-your-vpc-id"  # Add your VPC ID here
SUBNET_ID="subnet-0fb5735fa5d14f1b3"  # Add your subnet ID here
SECURITY_GROUP_ID="sg-025ddc4b02bb53af5"  # Add your security group ID here
ENABLE_INTERNET_ACCESS=true  # Set to false if internet access isn't needed

# Step 1: Create Image Builder
aws appstream create-image-builder \
  --name "$IMAGE_BUILDER_NAME" \
  --instance-type "$INSTANCE_TYPE" \
  --image-name "$BASE_IMAGE_NAME" \
  --iam-role-arn "$IAM_ROLE_ARN" \
  --domain-join-info "{\"DirectoryName\":\"$DIRECTORY_NAME\",\"OrganizationalUnitDistinguishedName\":\"$OU_DISTINGUISHED_NAME\"}"
  --vpc-id "$VPC_ID" \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --enable-default-internet-access "$ENABLE_INTERNET_ACCESS"

# Wait for the image builder to become available
echo "Waiting for Image Builder to become available..."
aws appstream wait image-builder-running --name "$IMAGE_BUILDER_NAME"

# Step 2: Create Custom Image
CUSTOM_IMAGE_NAME="god-appstream-$(date +%Y%m%d%H%M%S)"
aws appstream create-image \
  --name "$CUSTOM_IMAGE_NAME" \
  --image-builder-name "$IMAGE_BUILDER_NAME"

echo "Custom Image creation initiated: $CUSTOM_IMAGE_NAME"
