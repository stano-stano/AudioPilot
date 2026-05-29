# Release Guide

This guide is for maintainers preparing a public GitHub Release.

AudioPilot can be built locally with ad-hoc signing, but public distribution should use Developer ID signing and notarization so users do not hit avoidable Gatekeeper warnings.

## Release Checklist

1. Update version numbers:
   - `MARKETING_VERSION` in `AudioPilot.xcodeproj/project.pbxproj`
   - `CFBundleShortVersionString` if needed
   - `CHANGELOG.md`
2. Run tests:
   ```sh
   swift test
   xcodebuild \
     -project AudioPilot.xcodeproj \
     -scheme AudioPilot \
     -configuration Release \
     -derivedDataPath /private/tmp/AudioPilotReleaseDerivedData \
     test
   ```
3. Build a Release archive in Xcode or from Terminal.
4. Sign with a Developer ID Application certificate.
5. Verify the signature and entitlements.
6. Notarize with Apple.
7. Staple the notarization ticket.
8. Create a DMG containing `AudioPilot.app` and an `Applications` shortcut.
9. Notarize and staple the DMG if distributing the DMG directly.
10. Generate a SHA-256 checksum.
11. Create a GitHub Release with the DMG, checksum, source archive, and release notes.

## Build Archive

```sh
xcodebuild \
  -project AudioPilot.xcodeproj \
  -scheme AudioPilot \
  -configuration Release \
  -derivedDataPath /private/tmp/AudioPilotReleaseDerivedData \
  archive \
  -archivePath /private/tmp/AudioPilot.xcarchive
```

For public releases, configure signing in Xcode with your Apple Developer Team and a Developer ID Application certificate.

## Verify App

```sh
codesign --verify --deep --strict --verbose=2 /path/to/AudioPilot.app
codesign --display --entitlements - /path/to/AudioPilot.app
spctl --assess --type execute --verbose=4 /path/to/AudioPilot.app
```

Expected entitlement:

```xml
<key>com.apple.security.app-sandbox</key>
<true/>
```

## Notarize

Create a zip for notarization:

```sh
ditto -c -k --keepParent /path/to/AudioPilot.app /private/tmp/AudioPilot.zip
```

Submit to Apple:

```sh
xcrun notarytool submit /private/tmp/AudioPilot.zip \
  --keychain-profile "notarytool-profile" \
  --wait
```

Staple the ticket:

```sh
xcrun stapler staple /path/to/AudioPilot.app
```

## Create DMG

```sh
DMG_ROOT="$(mktemp -d)"
ditto /path/to/AudioPilot.app "$DMG_ROOT/AudioPilot.app"
ln -s /Applications "$DMG_ROOT/Applications"
hdiutil create \
  -volname AudioPilot \
  -srcfolder "$DMG_ROOT" \
  -ov \
  -format UDZO \
  AudioPilot-0.1.0-macos.dmg
```

Verify:

```sh
hdiutil verify AudioPilot-0.1.0-macos.dmg
shasum -a 256 AudioPilot-0.1.0-macos.dmg
```

## Release Title

```text
AudioPilot 0.1.0
```

## Release Body

```markdown
AudioPilot is a tiny privacy-friendly macOS menu bar app that notifies you when the default audio output device changes.

### Highlights

- Native macOS menu bar app.
- CoreAudio listener for default output device changes.
- Native UserNotifications alerts.
- Optional spoken device name, off by default.
- Launch at login toggle through modern macOS APIs.
- App Sandbox enabled with minimal entitlements.
- No telemetry, no analytics, no network access.

### Requirements

- macOS 13 Ventura or newer.

### Install

1. Download `AudioPilot-0.1.0-macos.dmg`.
2. Open the DMG.
3. Drag `AudioPilot.app` to `Applications`.
4. Launch AudioPilot.
5. Allow notifications when macOS asks.

### Privacy

AudioPilot does not request microphone, Accessibility, Screen Recording, AppleScript, or network permissions. It only observes the public CoreAudio default output device property and reads the output device name.

### Checksum

SHA-256:

```text
PASTE_CHECKSUM_HERE
```
```
