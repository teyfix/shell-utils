# shell-utils

shell-utils is a toolkit that I use in my daily routine. I created this
repository so that I can setup my new environment quickly whenever I need.

## Install

Bash, Zsh and fish are supported. The installer uses `$SHELL` to select the
startup file. Fish runs the existing Bash tools through `bootstrap.fish`.
After installation, open a new shell or run `source ~/shell-utils/bootstrap.fish`
in fish.

`clean-workspace` treats `node_modules`, `.next`, `.expo`, `dist`, and `.bun/install/cache` as disposable
and lists them before asking for deletion confirmation. Scanning and confirmed
deletion both use sudo. It searches inside `.state` and `.cache`
for these targets too, leaving other contents intact. `.git` is skipped.

Bun caches named `bun`, `bun-cache`, or `bun-clean-cache` inside `.cache` are
removed as single targets. `dist` directories inside `.cache/flutter/sdk` and
`.cache/dart/pub` are preserved because they belong to installed SDKs/packages.

### Install with cURL

```sh
curl -fsSL {{install_url}} | bash
```

### Install with wget

```sh
wget -qO- {{install_url}} | bash
```
