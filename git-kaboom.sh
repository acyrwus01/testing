#!/bin/bash

# Usage: ./script.sh <commit-hash>

# Exit if any command fails
set -e

# Check if commit hash is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <commit-hash>"
    exit 1
fi

COMMIT_HASH=$1

# Function to deinitialize unneeded submodules
deinit_unneeded_submodules() {
    # Get list of submodules at the specific commit
    local submodules_at_commit=$(git ls-tree -r $COMMIT_HASH | grep '^160000' | awk '{print $4}')

    # Get list of currently initialized submodules
    local current_submodules=$(git submodule status | awk '{print $2}')

    for submodule in $current_submodules; do
        if ! echo $submodules_at_commit | grep -q "$submodule"; then
            echo "Deinitializing unneeded submodule: $submodule"
            git submodule deinit -f "$submodule"
        fi
    done
}

# Checkout the specific commit
git checkout $COMMIT_HASH

# Update and initialize submodules
git submodule update --init --recursive

# Clean the repository (including submodules)
git clean -fdx
git submodule foreach --recursive git clean -fdx

# Reset submodules
git submodule foreach --recursive git reset --hard

# Deinitialize unneeded submodules
deinit_unneeded_submodules

echo "Repository and submodules reset to commit $COMMIT_HASH."

