cask "beeble" do
  version "0.2.0"
  sha256 "f84df9a4f7875deb1227b40f0a48850fee2b6ab1e30fa9daf002ea5a2cc98095"

  url "https://omnipotent.net/beeble/Beeble-#{version}.zip"
  name "Beeble"
  desc "Live workspace: video channels with shared folders"
  homepage "https://omnipotent.net/beeble/"

  depends_on macos: :sequoia
  auto_updates false

  app "Beeble.app"
  # The shims, NOT Contents/MacOS. CFBundle derives Bundle.main from the path a process was
  # invoked by, so a symlink straight to the binary makes it look for its resources next to
  # the symlink and abort. The shims re-exec by absolute real path.
  binary "#{appdir}/Beeble.app/Contents/Resources/bin/beeble"
  # Tab completion — symlinked into #{HOMEBREW_PREFIX}/etc/bash_completion.d and
  # #{HOMEBREW_PREFIX}/share/zsh/site-functions (BashCompletion strips the extension, so
  # beeble.bash lands as `beeble`). build.sh generates these by running the binary it just
  # built, so they can't be a version behind the CLI they complete.
  #
  # Same stance as `beeble shell init`: brew owns its own prefix, and nothing here edits a
  # file the user owns. bash before zsh, and no blank line above — `brew style` enforces
  # both, and the cask should not acquire new offences.
  bash_completion "#{appdir}/Beeble.app/Contents/Resources/completions/beeble.bash"
  zsh_completion "#{appdir}/Beeble.app/Contents/Resources/completions/_beeble"

  # brew will not quit a running app on its own, and replacing a live bundle mid-run is how
  # you get a half-upgraded app.
  uninstall quit: "net.omnipotent.beeble"

  zap trash: [
    "~/Library/Preferences/net.omnipotent.beeble.plist",
    "~/Library/Application Support/Beeble",
    "~/Library/Caches/net.omnipotent.beeble",
    "~/.beeble",
  ]

  # Keep this describing what THIS BUILD ships. An earlier version pointed at a
  # Preferences control and a generated ~/.beeble/shellrc.zsh, neither of which existed —
  # so anyone following it got no bridge and no error either, because the guard correctly
  # falls through to the real ssh. Aspirational instructions are worse than none, and the
  # same trap applies in reverse: do not describe a verb here before the build being
  # released actually has it.
  caveats <<~EOS
    The `beeble` command is now on your PATH. `beeble ssh <host>` gets you a normal ssh
    session with that host's folders bridged into your channel.

    Optional: let an ordinary `ssh` do the same, in the background.

      beeble shell init >> ~/.zshrc          # zsh
      beeble shell init >> ~/.bash_profile   # bash (not .bashrc — login shell)

    Then open a new terminal. To remove it, delete those lines.

    It never breaks ssh: if Beeble is closed, not in a channel, or given arguments it
    can't parse, it runs the real ssh and says nothing. Bypass it with `command ssh`.

    Tab completion is installed. Open a new terminal and try
    `beeble ls <TAB>` — it completes verbs, flags, peers, share names and paths.

      zsh:   if nothing happens, Homebrew's completions aren't on your $fpath. Add,
             before `compinit`:  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
      bash:  needs bash 4+ and bash-completion:  brew install bash bash-completion@2
             (macOS's built-in /bin/bash is 3.2, where it declines to register.)

    It never blocks: with Beeble closed it completes verbs and flags as usual and quietly
    offers nothing for peers and paths.
  EOS
end
