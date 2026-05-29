# Security

AudioPilot is intentionally small and local-first.

- It does not use the network.
- It does not request microphone access.
- It does not record, inspect, process, or transmit audio content.
- It does not use Accessibility, Screen Recording, AppleScript, shell scripts, kernel extensions, system extensions, or virtual audio drivers.
- It only watches the public CoreAudio default output device property and optionally posts a local macOS notification.

If you find a security issue, please open a private report through the repository hosting provider if available, or contact the maintainers directly before publishing details.
