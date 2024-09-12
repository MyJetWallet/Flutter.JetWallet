#!/bin/bash

# Script Name: generate_release_notes.sh
# Description: This script automatically generates release notes in JSON format for the project.
# It includes the current Git branch name and the last 5 commit messages.
#
# It performs the following tasks:
# 1. Retrieves the current Git branch name.
# 2. Retrieves the last 5 Git commit messages.
# 3. Creates a `release_notes.json` file in the root directory with the branch name and commit messages.
#
# Prerequisites:
# - Ensure Git is installed and configured in your environment.
# - Make sure you have the necessary permissions to execute this script. If not,
#   you may need to run `chmod +x generate_release_notes.sh` on macOS or Linux to make the script executable.
#
# Platform-specific Instructions:
# - For macOS/Linux:
#   1. Open Terminal and navigate to the `scripts` directory.
#   2. Make the script executable by running: `chmod +x generate_release_notes.sh`.
#   3. Execute the script by running: `./generate_release_notes.sh`.
#
# - For Windows:
#   1. Open Command Prompt or PowerShell and navigate to the `scripts` directory.
#   2. To run the script, you can use Git Bash or any other Bash emulator available for Windows.
#      If you are using Git Bash, you don't need to change permissions.
#   3. Execute the script by running: `./generate_release_notes.sh`.
#      Alternatively, you can run the script using `bash generate_release_notes.sh` if using Command Prompt or PowerShell.
#
# Usage:
# Run this script from the command line while in the `scripts` directory.
# Example: ./generate_release_notes.sh

# Move to the scripts directory
cd "$(dirname "$0")"

# Function to show progress
show_progress() {
  local msg=$1
  echo -n "$msg..."
}

# Function to execute commands with error handling
execute_command() {
  local cmd=$1
  local msg=$2

  show_progress "$msg"
  if bash -c "$cmd" > /dev/null 2>&1; then
    echo " done"
  else
    echo " failed"
    echo "Command '$msg' failed."
    exit 1
  fi
}

# Change to the root directory of the project
cd ..

# Get the current Git branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Get the last 5 commit messages and format them with \n for JSON
LAST_COMMITS=$(git log -5 --pretty=format:"%h %s" | awk '{printf "%s\\n", $0}')

# Generate release notes file
execute_command "cat > release_notes.json <<EOL
[
    {
        \"language\": \"en-GB\",
        \"text\": \"Git branch: $BRANCH_NAME\\n\\nLast commits:\\n$LAST_COMMITS\"
    }
]
EOL
" "Generating release notes"

# Notify the user of the successful creation of the release notes
echo "Release notes have been generated and saved in the root of the project."
