#!/bin/bash

# Exit if any command fails
set -e

# Function to deinitialize unneeded submodules
deinit_unneeded_submodules() {
    # Get list of submodules at the head of the branch
    local submodules_at_branch=$(git ls-tree -r $BRANCH_NAME | grep '^160000' | awk '{print $4}')

    # Get list of currently initialized submodules
    local current_submodules=$(git submodule status | awk '{print $2}')

    for submodule in $current_submodules; do
        if ! echo $submodules_at_branch | grep -q "$submodule"; then
            echo "Deinitializing unneeded submodule: $submodule"
            git submodule deinit -f "$submodule"
        fi
    done
}

# List all branches and use gum to select one
BRANCH_NAME=$(git branch -a | grep -v 'remotes' | sed 's/*//' | sed 's/ //' | gum choose)

if [ -z "$BRANCH_NAME" ]; then
    echo "No branch selected, exiting."
    exit 1
fi

# Checkout the selected branch
git checkout $BRANCH_NAME

# Update and initialize submodules
git submodule update --init --recursive

# Clean the repository (including submodules)
git clean -fdx
git submodule foreach --recursive git clean -fdx

# Reset submodules
git submodule foreach --recursive git reset --hard

# Deinitialize unneeded submodules
deinit_unneeded_submodules

echo "Repository and submodules reset to the latest commit of branch $BRANCH_NAME."

