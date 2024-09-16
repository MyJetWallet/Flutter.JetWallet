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
# Prerequisites:
# - Ensure Flutter and Dart are installed and added to your PATH environment variable.
#   This script requires Flutter and Dart to be accessible from the command line.
# - Make sure you have the necessary permissions to execute this script. If not,
#   you may need to run `chmod +x build_process.sh` on macOS or Linux to make the script executable.
# - The script assumes it is located in a `scripts` directory and that the project
#   structure includes a `plugins` directory with the necessary plugins.
#
# Platform-specific Instructions:
# - For macOS/Linux:
#   1. Open Terminal and navigate to the `scripts` directory.
#   2. Make the script executable by running: `chmod +x build_process.sh`.
#   3. Execute the script by running: `./build_process.sh`.
#
# - For Windows:
#   1. Open Command Prompt or PowerShell and navigate to the `scripts` directory.
#   2. To run the script, you can use Git Bash or any other Bash emulator available for Windows.
#      If you are using Git Bash, you don't need to change permissions.
#   3. Execute the script by running: `./build_process.sh`.
#      Alternatively, you can run the script using `bash build_process.sh` if using Command Prompt or PowerShell.
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
for plugin in ../plugins/sift ../plugins/simple_analytics ../plugins/simple_chart ../plugins/simple_kit ../plugins/simple_kit_updated ../plugins/simple_networking  ../plugins/share_plus; do
  execute_command "cd $plugin && flutter pub get" "Running flutter pub get for $(basename $plugin)"
done

# Run build_runner for each plugin
for plugin in ../plugins/simple_networking ../plugins/simple_kit ../plugins/simple_kit_updated; do
  execute_command "cd $plugin && dart run build_runner build --delete-conflicting-outputs" "Running build_runner for $(basename $plugin)"
done

# Run build_runner for the root project
cd ..
execute_command "dart run build_runner build --delete-conflicting-outputs" "Running build_runner for the root project"
