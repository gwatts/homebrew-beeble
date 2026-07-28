# Homebrew tap for Beeble

Beeble is a live workspace: video channels with shared folders.

## Install

```sh
brew tap gwatts/beeble
brew trust gwatts/beeble          # see below — required for any third-party cask
brew install --cask beeble
```

The `brew trust` step is not optional and not specific to Beeble. Homebrew refuses to
load a cask from a tap outside its own repositories until you say you trust it, and
without it `brew install` stops with:

```
Error: Refusing to load cask gwatts/beeble/beeble from untrusted tap gwatts/beeble.
```

You do it once per tap.

## What gets installed

| | |
|---|---|
| `/Applications/Beeble.app` | the app |
| `beeble` | the CLI — share folders into a channel, browse and copy peers' files |
| `beeblessh` | an `ssh` wrapper that bridges a remote host's folders while you're logged in |

Both commands are symlinked into Homebrew's `bin`, so they are already on your `PATH`.
They are launchers into the app bundle rather than standalone copies — the app must be
installed for them to work, and removing it removes them.

Beeble is signed with a Developer ID certificate and notarised by Apple, so it launches
without a Gatekeeper warning.

## Shell integration (optional)

`beeblessh` bridges a host explicitly. If you live on the same handful of servers, you
can let an ordinary `ssh` do it for you in the background instead:

```sh
beeble shell init >> ~/.zshrc          # zsh
beeble shell init >> ~/.bash_profile   # bash
```

Then open a new terminal. From then on `ssh prod` behaves exactly as it always did,
except Beeble quietly connects to that host at the same time, leaving you to run
`beeble share` there whenever you want something shared.

For bash that's `.bash_profile` and **not** `.bashrc` — macOS terminals start bash as a
*login* shell, which reads the former and never the latter, so appending to `.bashrc` is
the classic way to have this silently do nothing.

Nothing edits your startup file for you; `beeble shell init` just prints this, and you
redirect it where you want. To remove it, delete the lines.

```sh
ssh() {
    if command -v beeble >/dev/null 2>&1; then beeble sshwrap "$@"
    else command ssh "$@"
    fi
}
```

It is written not to break `ssh`. If anything goes wrong — Beeble closed, not in a
channel, arguments it can't make sense of — it runs the real `ssh` and says nothing. The
`command -v` guard is what keeps that true after you uninstall Beeble; without it you
would have no working `ssh` in any terminal until you edited the file back. Bypass it at
any time with `command ssh`.

It only affects interactive shells you start yourself: `git push`, `rsync` and scripts
call the real `ssh` and never trigger a bridge.

## Upgrade

```sh
brew upgrade --cask beeble
```

Beeble tells you in-app when a newer build is available. `brew upgrade` will quit the
app if it is running.

## Uninstall

```sh
brew uninstall --cask beeble        # app + both commands
brew uninstall --zap --cask beeble  # …and preferences, caches and ~/.beeble
```

## Requirements

macOS 15 (Sequoia) or later. The optional file-system extension, which mounts a
channel's shared folders as a volume, needs macOS 26.
