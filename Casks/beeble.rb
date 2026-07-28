cask "beeble" do
  version "0.1.0"
  sha256 "45974eea58ab923b5a19a11c102a51298ea8741b556f09733165a9e57955311c"

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
  binary "#{appdir}/Beeble.app/Contents/Resources/bin/beeblessh"

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
    The `beeble` and `beeblessh` commands are now on your PATH.

    Optional: let an ordinary `ssh` connect Beeble to that host in the background.

      beeble shell init >> ~/.zshrc          # zsh
      beeble shell init >> ~/.bash_profile   # bash (not .bashrc — login shell)

    Then open a new terminal. To remove it, delete those lines.

    It never breaks ssh: if Beeble is closed, not in a channel, or given arguments it
    can't parse, it runs the real ssh and says nothing. Bypass it with `command ssh`.
  EOS
end
