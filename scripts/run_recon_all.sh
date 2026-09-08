#!/bin/bash


echo "Preparing to run FreeSurfer recon-all with T2-guided pial refinement..."

set -euo pipefail

if [ -z "${FREESURFER_HOME:-}" ] || [ ! -d "$FREESURFER_HOME" ]; then
  echo "Error: FREESURFER_HOME is not set or directory does not exist."
  exit 1
fi

echo "Using FreeSurfer installation at: '$FREESURFER_HOME'"

# Must be run from repository root
if [ ! -d "scripts" ]; then
  echo "Error: Please run this script from the root of the repository."
  exit 1
fi

echo "Run directory seems okay: $(pwd)"

echo "Trying to determine FreeSurfer version from 'mri_convert --version' output..."

# Extract version (supports X.Y or X.Y.Z)
FREESURFER_VERSION=$(mri_convert --version 2>&1 | grep -oP 'freesurfer \K[0-9]+(\.[0-9]+)+' | head -n 1)

if [[ ! "$FREESURFER_VERSION" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
  echo "Error: Failed to determine FreeSurfer version from mri_convert."
  exit 1
else
  echo "Detected FreeSurfer version: $FREESURFER_VERSION"
fi



export SUBJECTS_DIR="$PWD/derived/FreeSurfer/${FREESURFER_VERSION}/subjects_dir"
mkdir -p "$SUBJECTS_DIR"

echo "Running recon-all for subject sub-01 with T2-guided pial refinement, will write outputs to: '$SUBJECTS_DIR'"

# Run full reconstruction with T2-guided pial refinement
recon-all \
  -s sub-01 \
  -i ./DICOM/0002_MR000004.dcm \
  -T2 ./DICOM/0004_MR000388.dcm \
  -T2pial \
  -all \
  -threads 8

