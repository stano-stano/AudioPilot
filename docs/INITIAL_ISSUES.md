# Initial Issues To Open

These are ready-to-paste GitHub issues for the first public week.

## 1. Test AudioPilot On More macOS Setups

Labels: `help wanted`, `compatibility`, `good first issue`

```markdown
AudioPilot targets macOS 13 Ventura and newer. It would help to confirm behavior across more real setups.

Please test:

- Launching the app.
- Notification permission prompt.
- Switching between at least two output devices.
- Menu item showing the current output.
- Optional "Speak device name" toggle.
- Optional "Launch at login" toggle.

Comment with:

- macOS version.
- Mac model or chip family.
- Output devices tested.
- Whether notifications appeared correctly.
- Any odd behavior.
```

## 2. Add README Screenshots Or A Short GIF

Labels: `documentation`, `help wanted`, `good first issue`

```markdown
The README would benefit from a small screenshot or short GIF showing:

- The menu bar icon.
- The dropdown menu.
- A notification after switching audio output.

The image should avoid personal device names or private desktop content.
```

## 3. Improve Release Packaging Notes

Labels: `release`, `documentation`

```markdown
The release guide covers signing, notarization, stapling, and DMG creation. It would be useful to have a maintainer-tested path once the first Developer ID release is prepared.

Acceptance criteria:

- Commands verified on a clean macOS machine.
- Notes for Xcode Organizer and Terminal workflows.
- Clear distinction between local ad-hoc builds and public notarized releases.
```

## 4. Localization Proposal

Labels: `enhancement`, `localization`, `discussion`

```markdown
AudioPilot currently uses English menu and notification text.

Proposal:

- Add localizable strings.
- Start with Slovak and English.
- Keep wording short enough for menu bar UI.

Open question:

- Should the app follow system language automatically, or offer a simple language override?
```

## 5. Verify Menu Bar Icon Contrast

Labels: `design`, `accessibility`, `help wanted`

```markdown
The status bar icon is a template image so macOS can tint it for light/dark menu bars.

Please test:

- Light mode.
- Dark mode.
- High contrast/increase contrast settings.
- Different menu bar backgrounds.

Comment with screenshots if the icon looks too heavy, too light, or blurry.
```

## 6. Consider A Notification Sound Toggle

Labels: `enhancement`, `discussion`

```markdown
AudioPilot currently uses the default notification sound when notifications are enabled.

Would a separate "Play notification sound" toggle be useful, or is that too much preference surface for a tiny utility?

Constraints:

- Keep default behavior simple.
- Do not add custom audio assets unless there is a strong reason.
- Respect system notification settings.
```
