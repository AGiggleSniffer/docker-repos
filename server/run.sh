#!/bin/bash

# This script finds and runs 'compose.yaml'
# files in each immediate subdirectory of where this script is located.

echo "--- Starting Docker Compose Deployment ---"

# Loop through all subdirectories in the current directory
# The '*/' pattern expands to all directories (and symlinks to directories)
# in the current path, excluding hidden ones.
for dir in */; do
    # Remove the trailing slash to get just the directory name
    dir_name="${dir%/}"

    echo ""

    COMPOSE_FILE="$dir_name/compose.yaml"

    # Check if a Docker Compose file was found in this directory
    if [ -f "$COMPOSE_FILE" ]; then
        echo "Processing directory: $dir_name"
        echo "Found Compose file: $(basename "$COMPOSE_FILE")"
        echo "Deploying stack for '$dir_name'..."

        # Change into the subdirectory to run docker compose
        cd "$dir_name" || { echo "Error: Could not enter directory $dir_name. Skipping."; continue; }

        # Run docker compose up in detached mode
        if docker compose up -d; then
            echo "Successfully deployed stack for '$dir_name'."
        else
            echo "Error: Failed to deploy stack for '$dir_name'. Please check the output above for details."
        fi

        # Change back to the parent directory before the next loop iteration
        cd .. || { echo "Error: Could not return to parent directory. Exiting."; exit 1; }
    else
        echo "No 'compose.yaml' or 'docker-compose.yml' found in '$dir_name'. Skipping."
    fi
done

echo ""
echo "--- Docker Compose Deployment Finished ---"
