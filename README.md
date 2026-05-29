# AudioPilot

<p align="center">
  <img src="Resources/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width="128" alt="AudioPilot app icon">
</p>

**A tiny Mac menu bar app that tells you when your sound output changes.**

AudioPilot sits quietly in the menu bar. When macOS switches from your speakers to AirPods, a monitor, a dock, or another output device, it shows a native notification:

```text
Audio output changed
Now playing through: AirPods Pro
```

That is it. Small, useful, and out of the way.

![macOS 13+](https://img.shields.io/badge/macOS-13%2B-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![MIT](https://img.shields.io/badge/license-MIT-blue)
![No network](https://img.shields.io/badge/network-none-brightgreen)

## What You Get

- A quiet menu bar app with no Dock icon.
- A notification when the default audio output changes.
- The current output device in the menu.
- A toggle for notifications.
- An optional "Speak device name" toggle, off by default.
- An optional "Launch at login" toggle.

## Privacy

AudioPilot is local-only.

It does not use the microphone. It does not record, listen to, inspect, or upload audio. It does not use the network. It does not need Accessibility, Screen Recording, AppleScript, shell scripts, system extensions, or virtual audio drivers.

It only asks macOS one simple question: "What is the current output device called?"

The only prompt you should normally see is the macOS notification permission prompt.

## Install

A signed and notarized public download is not published yet.

For now, build AudioPilot locally from source:

```sh
xcodebuild \
  -project AudioPilot.xcodeproj \
  -scheme AudioPilot \
  -configuration Debug \
  -derivedDataPath /private/tmp/AudioPilotDerivedData \
  build
```

Then open:

```sh
open /private/tmp/AudioPilotDerivedData/Build/Products/Debug/AudioPilot.app
```

AudioPilot appears in the menu bar.

## Develop

Requirements:

- macOS 13 Ventura or newer
- Xcode 15 or newer recommended
- Swift 5.9 or newer

Run tests:

```sh
swift test
```

Build with SwiftPM:

```sh
swift build
```

Use the Xcode project when you need the real macOS app bundle, icon, sandbox entitlements, and menu bar behavior.

## Project Notes

AudioPilot uses public Apple APIs:

- CoreAudio for output device changes.
- UserNotifications for local notifications.
- ServiceManagement for launch at login.
- AppKit for the menu bar app.

More detail lives in the docs:

- [Architecture](docs/ARCHITECTURE.md)
- [Release guide](docs/RELEASE.md)
- [Contributing](CONTRIBUTING.md)
- [Security](SECURITY.md)

## License

MIT. See [LICENSE](LICENSE).
