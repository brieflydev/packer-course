#!/usr/bin/env bash
set -euo pipefail

NAME_PREFIX="${1:-nginx-web}"
REGION="${AWS_REGION:-eu-central-1}"

AMI_IDS=$(aws ec2 describe-images \
  --region "$REGION" \
  --owners self \
  --filters "Name=name,Values=${NAME_PREFIX}-*" \
  --query 'Images[].ImageId' \
  --output text)

if [ -z "$AMI_IDS" ]; then
  echo "No AMIs named ${NAME_PREFIX}-* found in ${REGION}"
  exit 0
fi

for AMI_ID in $AMI_IDS; do
  echo "Deregistering ${AMI_ID} and deleting its snapshots"
  aws ec2 deregister-image \
    --region "$REGION" \
    --image-id "$AMI_ID" \
    --delete-associated-snapshots \
    --query 'DeleteSnapshotResults[].[SnapshotId,ReturnCode]' \
    --output text
done