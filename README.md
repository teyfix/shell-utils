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
curl -fsSL https://raw.githubusercontent.com/teyfix/shell-utils/5a33688239095c9773b1d1e1264ed1a7da6615a2/install.sh | bash
```

### Install with wget

```sh
wget -qO- https://raw.githubusercontent.com/teyfix/shell-utils/5a33688239095c9773b1d1e1264ed1a7da6615a2/install.sh | bash
```
