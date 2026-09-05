#!/bin/bash
set -e

# setup_host_muspelheim.sh
# Prepares the Muspelheim host directories for the Immich stack.
# Usage: ./setup_host_muspelheim.sh via SSH on the target node (Muspelheim)

echo "Setting up Immich directories on Muspelheim..."

# Photo/video library — mergerfs storage pool (JBOD). The bulk of the data.
LIBRARY_DIR="/mnt/storage/immich/library"
if [ ! -d "${LIBRARY_DIR}" ]; then
    echo "Creating ${LIBRARY_DIR}..."
    sudo mkdir -p "${LIBRARY_DIR}"
    sudo chown -R 1000:1000 "${LIBRARY_DIR}"
fi

# PostgreSQL data — local system disk (NOT mergerfs; postgres dislikes pooled/
# fuse filesystems). The postgres image chowns this dir to the postgres user on
# first init, so leave it root-owned here.
POSTGRES_DIR="/opt/immich/postgres"
if [ ! -d "${POSTGRES_DIR}" ]; then
    echo "Creating ${POSTGRES_DIR}..."
    sudo mkdir -p "${POSTGRES_DIR}"
fi

# Machine-learning model cache (CLIP + facial-recognition models).
MODEL_CACHE_DIR="/opt/immich/model-cache"
if [ ! -d "${MODEL_CACHE_DIR}" ]; then
    echo "Creating ${MODEL_CACHE_DIR}..."
    sudo mkdir -p "${MODEL_CACHE_DIR}"
    sudo chown -R 1000:1000 "${MODEL_CACHE_DIR}"
fi

echo "Done. Muspelheim is ready for Immich deployment."
