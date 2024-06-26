#!/bin/bash
install_shell_utils() {
  # Check for Git installation
  if ! command -v git &>/dev/null; then
    echo "Git is not installed. Please install Git and try again." >&2
    return 1
  fi

  # Define the directory where the repository is to be cloned or updated
  local REPO_DIR="$HOME/shell-utils"
  # Define the branch you want to reset to
  local RESET_BRANCH="main"
  # Define the profile file to source the shell-utils
  local PROFILE_FILE="$HOME/.$(basename "$SHELL")rc"

  if [ -z "$PROFILE_FILE" ]; then
    echo "Could not determine the profile file, this is required to install shell-utils." >&2
    return 1
  fi

  if [ ! -f "$PROFILE_FILE" ]; then
    echo "You don't have the profile file \"$PROFILE_FILE\". Please create one and try again." >&2
    return 1
  fi

  # Git operations: clone, pull, or reset
  if [ -d "$REPO_DIR" ]; then
    pushd "$REPO_DIR" >/dev/null
    if ! git symbolic-ref -q HEAD >/dev/null; then
      echo "Detached installation, resetting..."

      git fetch origin && git reset --hard "origin/$RESET_BRANCH" && git clean -df

      if [ $? -ne 0 ]; then
        echo "Failed to reset installation. Exiting..."
        popd >/dev/null
        return 1
      fi
    else
      echo "Updating installation..."

      if ! git pull; then
        echo "Failed to update! Exiting..." >&2
        popd >/dev/null
        return 1
      fi
    fi
    popd >/dev/null
  else
    echo "Installing shell-utils..."
    if ! git clone https://github.com/teyfik-on-it/shell-utils.git "$REPO_DIR"; then
      echo "Failed to install shell-utils! Exiting..." >&2
      return 1
    fi
  fi

  local SOURCE_COMMAND="source \"$REPO_DIR/bootstrap.sh\""

  # Check if the source command is already in the profile file
  if grep -qx "$SOURCE_COMMAND" "$PROFILE_FILE"; then
    echo "The source command is already in $PROFILE_FILE"
    return 0
  fi

  echo "$SOURCE_COMMAND" >>"$PROFILE_FILE"

  if grep -qx "$SOURCE_COMMAND" "$PROFILE_FILE"; then
    echo "Added source command to $PROFILE_FILE"
    return 0
  fi

  echo "Failed to add source command to $PROFILE_FILE" >&2
  return 1
}

install_shell_utils
