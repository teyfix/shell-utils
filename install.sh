# Define the directory where the repository is to be cloned or updated
REPO_DIR=~/shell-utils
# Define the branch you want to reset to
RESET_BRANCH="main"

# Git operations: clone, pull, or reset
if [ -d "$REPO_DIR" ]; then
  echo "Directory exists. Checking repository state..."
  cd "$REPO_DIR"
  if ! git symbolic-ref -q HEAD >/dev/null; then
    echo "Repository is in a detached HEAD state. Resetting..."
    git fetch origin
    git reset --hard "origin/$RESET_BRANCH"
    git clean -df
  else
    echo "Repository is not in a detached HEAD state. Pulling updates..."
    git pull
  fi
else
  echo "Directory does not exist. Cloning repository..."
  git clone https://github.com/teyfik-on-it/shell-utils.git "$REPO_DIR"
fi

# Assuming install.sh is within the cloned or updated repository
SOURCE_COMMAND="source $REPO_DIR/install.sh"

# Determine the profile file based on the current shell
SHELL_NAME=$(basename $SHELL)
if [ "$SHELL_NAME" = "bash" ]; then
  # Adapt for macOS or environments that use .bash_profile or .profile
  if [ -f "$HOME/.bash_profile" ]; then
    PROFILE_FILE="$HOME/.bash_profile"
  elif [ -f "$HOME/.profile" ]; then
    PROFILE_FILE="$HOME/.profile"
  else
    PROFILE_FILE="$HOME/.bashrc"
  fi
elif [ "$SHELL_NAME" = "zsh" ]; then
  PROFILE_FILE="$HOME/.zshrc"
else
  echo "Unsupported shell. Please manually update your shell profile."
  exit 1
fi

# Check if the source command is already in the profile file
if grep -qF -- "$SOURCE_COMMAND" "$PROFILE_FILE"; then
  echo "The source command is already in the $PROFILE_FILE"
else
  echo "$SOURCE_COMMAND" >>"$PROFILE_FILE"
  echo "Added source command to $PROFILE_FILE"
fi
