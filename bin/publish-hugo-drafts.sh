#!/usr/bin/env bash
set -euo pipefail

PUBLIC_DIR="${1:-public}"
DEV_DIR="dev"

# Build drafts to dev dir
hugo --cleanDestinationDir -D -d "${DEV_DIR}" > /dev/null

# Build the site (without drafts) to PUBLIC_DIR
hugo --cleanDestinationDir -d "${PUBLIC_DIR}"

# Copy drafts files
rsync -ri --ignore-existing "${DEV_DIR}"/ "${PUBLIC_DIR}"
