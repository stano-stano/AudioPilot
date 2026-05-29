# Contributing To AudioPilot

Thanks for helping make AudioPilot better.

AudioPilot is intentionally small. Contributions should preserve that shape: a quiet menu bar app, public Apple APIs, no telemetry, no network calls, and no sensitive permissions unless the change is discussed first.

## Good First Contributions

- Test AudioPilot on another macOS version and report the result.
- Improve wording in README or docs.
- Add a small unit test around pure Swift logic.
- Improve menu bar icon contrast or release packaging docs.
- Add a localization proposal for the menu strings.

## Development Setup

Requirements:

- macOS 13 Ventura or newer
- Xcode 15 or newer recommended
- Swift 5.9 or newer

Build:

```sh
xcodebuild \
  -project AudioPilot.xcodeproj \
  -scheme AudioPilot \
  -configuration Debug \
  -derivedDataPath /private/tmp/AudioPilotDerivedData \
  build
```

Test:

```sh
xcodebuild \
  -project AudioPilot.xcodeproj \
  -scheme AudioPilot \
  -configuration Debug \
  -derivedDataPath /private/tmp/AudioPilotDerivedData \
  test
```

SwiftPM validation:

```sh
swift build
swift test
```

## Code Style

- Prefer small, readable Swift types.
- Keep CoreAudio code isolated in `AudioOutputMonitor`.
- Keep notification behavior isolated in `NotificationService`.
- Put testable pure logic in `Sources/AudioPilotCore`.
- Avoid unrelated formatting churn.
- Add comments only where they clarify a non-obvious system API edge case.

## Privacy Guardrails

Please do not add:

- Telemetry, analytics, crash reporting SDKs, or network calls.
- Microphone, camera, Accessibility, Screen Recording, Apple Events, or automation permissions.
- AppleScript, runtime shell scripts, kernel extensions, system extensions, or virtual audio drivers.
- Private Apple APIs.

If a proposed change would require one of these, open an issue first and explain the user benefit, alternatives, and exact permission impact.

## Pull Requests

Before opening a pull request:

1. Keep the change focused.
2. Add or update tests when the change touches testable logic.
3. Run `swift build` and `swift test`.
4. Run the Xcode build when the change touches the app bundle, resources, entitlements, or Info.plist.
5. Update README/docs if behavior, privacy, permissions, or release steps change.

## Release Work

Release packaging, signing, notarization, and GitHub Release notes are documented in [docs/RELEASE.md](docs/RELEASE.md).
