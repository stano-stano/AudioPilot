# AudioPilot

<p align="center">
  <img src="Resources/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width="128" alt="AudioPilot app icon">
</p>

AudioPilot is a tiny, privacy-friendly macOS menu bar app that tells you when the default audio output device changes.

```text
Audio output changed
Now playing through: AirPods Pro
```

It is built for people who switch between speakers, displays, headphones, docks, AirPods, and audio interfaces all day and want a quiet confirmation when macOS changes the route.

![Platform](https://img.shields.io/badge/platform-macOS%2013%2B-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![License](https://img.shields.io/badge/license-MIT-blue)
![Privacy](https://img.shields.io/badge/network-none-brightgreen)

## Features

- Menu bar only app, with no Dock icon.
- Native macOS notification when the default output device changes.
- Current output device shown in the menu.
- Optional "Speak device name" mode, off by default.
- Optional "Launch at login" through modern macOS APIs.
- App Sandbox enabled with a minimal entitlement.
- No telemetry, no analytics, no network calls.

## Privacy And Permissions

AudioPilot uses only public Apple APIs:

- CoreAudio, to observe the system default output device property.
- UserNotifications, to display local macOS notifications.
- ServiceManagement, to register the app as a launch-at-login item when requested.
- AppKit, for the menu bar UI and optional speech.

It does not request microphone access. It does not inspect, record, process, or transmit audio content. It does not use Accessibility, Screen Recording, AppleScript, runtime shell scripts, kernel extensions, system extensions, virtual audio drivers, or private APIs.

The only macOS prompt you should normally see is the notification permission prompt. macOS may also show a Login Items confirmation if you enable launch at login.

## Install

For now, AudioPilot is source-first. A signed and notarized public DMG should be attached to GitHub Releases once maintainers have configured Developer ID signing.

Local development DMGs may be useful for testing installation flow, but they are not a substitute for a notarized public release.

## Build

Requirements:

- macOS 13 Ventura or newer
- Xcode 15 or newer recommended
- Swift 5.9 or newer

Build the app bundle:

```sh
xcodebuild \
  -project AudioPilot.xcodeproj \
  -scheme AudioPilot \
  -configuration Debug \
  -derivedDataPath /private/tmp/AudioPilotDerivedData \
  build
```

Run tests:

```sh
xcodebuild \
  -project AudioPilot.xcodeproj \
  -scheme AudioPilot \
  -configuration Debug \
  -derivedDataPath /private/tmp/AudioPilotDerivedData \
  test
```

Keeping DerivedData outside the repository is recommended when the checkout is stored in iCloud Drive. FileProvider extended attributes in iCloud-managed folders can make local ad-hoc signing fail with resource fork/Finder metadata errors.

You can also compile the Swift sources and run the pure logic tests with SwiftPM:

```sh
swift build
swift test
```

SwiftPM is useful for validation and test feedback. Use the Xcode project when you want the real macOS `.app` bundle with `LSUIElement`, App Sandbox entitlements, resources, and local app signing.

## Run

After a Terminal build, the app bundle is located at:

```text
/private/tmp/AudioPilotDerivedData/Build/Products/Debug/AudioPilot.app
```

Open it from Finder or run:

```sh
open /private/tmp/AudioPilotDerivedData/Build/Products/Debug/AudioPilot.app
```

AudioPilot appears only in the menu bar.

## Create A Local DMG

For a local smoke test, create a simple DMG containing `AudioPilot.app` and an `Applications` shortcut:

```sh
DMG_ROOT="$(mktemp -d)"
ditto /private/tmp/AudioPilotDerivedData/Build/Products/Debug/AudioPilot.app "$DMG_ROOT/AudioPilot.app"
ln -s /Applications "$DMG_ROOT/Applications"
hdiutil create -volname AudioPilot -srcfolder "$DMG_ROOT" -ov -format UDZO AudioPilot-0.1.0-macos.dmg
```

For a public GitHub release, build a signed Release app, notarize it, staple the ticket, package it into a DMG, notarize/staple the DMG, and publish the checksum. See [docs/RELEASE.md](docs/RELEASE.md).

## Settings

User-facing settings are stored in `UserDefaults`:

- Show notifications, default on.
- Speak device name, default off.

Launch at login is managed by macOS through `SMAppService`; AudioPilot does not write custom launch agents.

## Project Shape

- `Sources/AudioPilot`: app lifecycle, menu bar UI, CoreAudio monitoring, notifications, speech, login item handling.
- `Sources/AudioPilotCore`: small testable value types and utility logic.
- `Tests/AudioPilotTests`: unit tests for logic that does not require CoreAudio.
- `Resources`: app icon asset catalog and template status bar icon.
- `.github`: issue templates, pull request template, and CI workflow.
- `docs`: architecture, release, and GitHub publishing notes.

## Contributing

Small, focused contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

The most important project rules are simple:

- Keep the app local-only.
- Use public Apple APIs.
- Do not add telemetry, analytics, or network behavior.
- Do not add sensitive permission requirements unless there is a clear, documented reason and community agreement.

## Signing And Notarization

The project is configured for local ad-hoc signing so it can be built and tested without a paid developer account.

Before a public release, maintainers should:

1. Set a stable production bundle identifier.
2. Configure an Apple Developer Team in Xcode.
3. Create a signed Release archive.
4. Use Hardened Runtime for distribution.
5. Notarize the app or final DMG with Apple.
6. Staple the notarization ticket.
7. Publish a GitHub Release with the DMG, checksum, source archive, and release notes.

## License

AudioPilot is available under the MIT License. See [LICENSE](LICENSE).
