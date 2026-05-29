# Architecture

AudioPilot is intentionally small. The app has one job: notice when macOS changes the default audio output device and tell the user.

## Runtime Flow

1. `AppDelegate` starts the menu bar app and creates the menu.
2. `AudioOutputMonitor` reads the current default output device.
3. `AudioOutputMonitor` registers a CoreAudio property listener for `kAudioHardwarePropertyDefaultOutputDevice`.
4. CoreAudio invokes the listener when the default output device changes.
5. A short debounce coalesces bursts of events.
6. The app compares the new device with the last known device.
7. If it changed, `AppDelegate` updates the menu and optionally calls:
   - `NotificationService`, for a native macOS notification.
   - `SpeechService`, for optional spoken device name feedback.

## Main Types

- `AppDelegate`: App lifecycle, menu bar item, menu commands, preference toggles.
- `AudioOutputMonitor`: CoreAudio property listener and output device name lookup.
- `NotificationService`: UserNotifications authorization and delivery.
- `SpeechService`: Optional local speech through AppKit.
- `LoginItemService`: Launch at login through `SMAppService.mainApp`.
- `Preferences`: `UserDefaults` wrapper for user-facing settings.
- `Debouncer`: Small testable utility for coalescing short event bursts.
- `AudioDeviceInfo`: Value type for current output device state.

## Edge Cases

- No default output device: represented as an unavailable device.
- Device name cannot be read: the UI falls back to a friendly unknown-device label.
- Multiple events in quick succession: debounced before publishing.
- First launch: the current device is captured before listening, so no false notification is shown.

## Privacy Boundary

AudioPilot reads the identity/name of the default output device. It does not read audio samples, record audio, inspect apps that are playing sound, or use the microphone.

The app does not perform network requests and has no network entitlement.
