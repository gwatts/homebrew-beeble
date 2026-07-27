cask "beeble" do
  version "0.1.0"
  sha256 "507cb2cafba85e5a7211ad58524b7e281dd1db2c7cc322d07a2f22a0b995fdab"

  url "https://omnipotent.net/beeble/Beeble-#{version}.zip"
  name "Beeble"
  desc "Live workspace: video channels with shared folders"
  homepage "https://omnipotent.net/beeble/"

  depends_on macos: ">= :sequoia"
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

  caveats <<~EOS
    The `beeble` and `beeblessh` commands are now on your PATH.

    To let `ssh` bridge a remote host's folders into your channel, install the shell
    integration from Beeble's Preferences, or add this to your ~/.zshrc by hand:

      [ -r "$HOME/.beeble/shellrc.zsh" ] && . "$HOME/.beeble/shellrc.zsh"
  EOS
end
