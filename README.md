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

Download the latest preview build from [GitHub Releases](https://github.com/stano-stano/AudioPilot/releases).

Developer ID signing and Apple notarization are still on the roadmap, so macOS may show an extra Gatekeeper warning for early builds.

AudioPilot appears in the menu bar.

## Roadmap

AudioPilot should stay small: a quiet Mac menu bar app that tells you when your sound output changes. This roadmap is a guide, not a promise of dates.

**Now**

- Keep the app reliable on macOS 13 Ventura and newer.
- Test output switching with more real devices, including AirPods, displays, docks, USB audio interfaces, and built-in speakers.
- Prepare the first signed and notarized public release.
- Add a README screenshot or short demo GIF.

**Next**

- Add localization support.
- Improve notification wording if device names are confusing.
- Consider a separate notification sound toggle.
- Improve menu bar icon contrast across macOS appearances.

**Later**

- Add a small preferences window if the menu becomes too crowded.
- Add an option to ignore selected devices.

**Not Planned**

- Microphone access, audio recording, per-app routing, volume mixing, telemetry, network sync, virtual audio drivers, kernel extensions, or system extensions.

## For Developers

Want to build from source or contribute? Start here:

- [Contributing](CONTRIBUTING.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Release guide](docs/RELEASE.md)
- [Security](SECURITY.md)

## License

MIT. See [LICENSE](LICENSE).
