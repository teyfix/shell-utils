# shell-utils

shell-utils is a toolkit that I use in my daily routine. I created this
repository so that I can setup my new environment quickly whenever I need.

## Install

Bash, Zsh and fish are supported. The installer uses `$SHELL` to select the
startup file. Fish runs the existing Bash tools through `bootstrap.fish`.
After installation, open a new shell or run `source ~/shell-utils/bootstrap.fish`
in fish.

### Install with cURL

```sh
curl -fsSL https://raw.githubusercontent.com/teyfix/shell-utils/b306576c84d5b7c9777a40c4a24fef70c9fd0efe/install.sh | bash
```

### Install with wget

```sh
wget -qO- https://raw.githubusercontent.com/teyfix/shell-utils/b306576c84d5b7c9777a40c4a24fef70c9fd0efe/install.sh | bash
```
