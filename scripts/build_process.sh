#!/bin/bash

# Script Name: build_process.sh
# Description: This script manages Dart and Flutter build processes for the project.
#
# It performs the following tasks:
# 1. Runs `flutter pub get` for the root project to fetch dependencies.
# 2. Runs `flutter pub get` for each plugin located in the `plugins` directory.
# 3. Executes `dart run build_runner build --delete-conflicting-outputs` for each plugin.
# 4. Runs the same `build_runner` command for the root project.
#
# Notes:
# - Ensure Flutter is installed and added to your PATH environment variable.
#   This script requires Flutter to be accessible from the command line.
# - The script assumes it is located in a `scripts` directory and that the project
#   structure includes a `plugins` directory with the necessary plugins.
# - The script provides status messages indicating whether each command completed
#   successfully or failed.
#
# Usage:
# Run this script from the command line while in the `scripts` directory.
# Example: ./build_process.sh

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

# Save the current directory
original_dir=$(pwd)

# Change to the root directory of the project
cd ..

# Run flutter pub get for the root project
execute_command "flutter pub get" "Running flutter pub get for the root project"

# Change back to the scripts directory
cd "$original_dir"

# Run flutter pub get for each plugin
for plugin in ../plugins/simple_networking ../plugins/simple_kit ../plugins/simple_kit_updated; do
  execute_command "cd $plugin && flutter pub get" "Running flutter pub get for $(basename $plugin)"
done

# Run build_runner for each plugin
for plugin in ../plugins/simple_networking ../plugins/simple_kit ../plugins/simple_kit_updated; do
  execute_command "cd $plugin && dart run build_runner build --delete-conflicting-outputs" "Running build_runner for $(basename $plugin)"
done

# Run build_runner for the root project
cd ..
execute_command "dart run build_runner build --delete-conflicting-outputs" "Running build_runner for the root project"