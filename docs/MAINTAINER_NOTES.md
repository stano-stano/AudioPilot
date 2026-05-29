# Maintainer Notes

## Project Principles

- Tiny utility, not an audio control center.
- Public Apple APIs only.
- No telemetry or network behavior.
- No microphone, Accessibility, Screen Recording, Apple Events, or automation permissions.
- App Sandbox stays enabled unless a public Apple API requires otherwise and the reason is documented.

## Triage Rhythm

A healthy lightweight cadence:

- Weekly: respond to new issues and discussions.
- Before merging: confirm privacy checklist and CI.
- Before release: run through `docs/RELEASE.md`.
- After release: open a compatibility testing issue for real-world reports.

## Scope Filter

Good fit:

- Better reliability around output device change detection.
- Clearer notification/menu behavior.
- Packaging, signing, notarization, docs.
- Accessibility and localization.

Usually not a fit:

- Volume mixers.
- Per-app audio routing.
- Audio recording or analysis.
- Virtual audio devices.
- Network sync.
- Menu bar dashboards with many controls.

## Public Response Snippet For Permission Questions

```text
AudioPilot only observes the public CoreAudio default output device property and reads the device name. It does not access the microphone, record or inspect audio, use Accessibility or Screen Recording, or make network requests.
```
