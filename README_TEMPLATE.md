# shell-utils

shell-utils is a toolkit that I use in my daily routine. I created this
repository so that I can setup my new environment quickly whenever I need.

## Install

Bash, Zsh and fish are supported. The installer uses `$SHELL` to select the
startup file. Fish runs the existing Bash tools through `bootstrap.fish`.
After installation, open a new shell or run `source ~/shell-utils/bootstrap.fish`
in fish.

`clean-workspace` treats `node_modules`, `.next`, `.expo`, `dist`, and `.bun/install/cache` as disposable
and lists them before asking for deletion confirmation. Confirmed deletion uses
sudo; scanning retries with sudo if needed. `.git`, `.state`, and `.cache` are skipped.

### Install with cURL

```sh
curl -fsSL {{install_url}} | bash
```

### Install with wget

```sh
wget -qO- {{install_url}} | bash
```
