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

To make `ssh` transparently bridge a remote host's folders into your current channel,
install the shell integration from Beeble's Preferences, or add this to your `~/.zshrc`
by hand:

```sh
[ -r "$HOME/.beeble/shellrc.zsh" ] && . "$HOME/.beeble/shellrc.zsh"
```

Using bash on macOS, put it in `~/.bash_profile` rather than `~/.bashrc` — terminals
usually start bash as a *login* shell, which reads the former and not the latter.

The guard matters: it means an uninstalled or not-yet-configured Beeble leaves you with
a working `ssh`, rather than no `ssh` at all in every terminal until you edit the file
back.

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
