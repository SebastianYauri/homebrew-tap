cask "clawdy" do
  version "1.4.7"
  sha256 "6402eab274379ffebe155367fce22c3b53fda22253b5e33accf4a1c6a85e3eac"

  url "https://github.com/SebastianYauri/clawdy/releases/download/v#{version}/Clawdy-mac.zip"
  name "Clawdy"
  desc "Animated desktop buddy that shows your Claude usage"
  homepage "https://github.com/SebastianYauri/clawdy"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64

  app "Clawdy.app"

  # Not signed with a paid Apple Developer ID: let it open without the Gatekeeper prompt.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Clawdy.app"]
  end

  # Disconnect it from Claude Code and stop it opening at login.
  uninstall early_script: {
              executable: "#{appdir}/Clawdy.app/Contents/MacOS/Clawdy",
              args:       ["--uninstall"],
              must_succeed: false,
            },
            quit:         "com.clawdy.app"

  zap trash: [
    "~/Library/Application Support/clawdy",
    "~/Library/Caches/clawdy",
  ]
end
