# Changelog

All notable changes to AudioPilot will be documented here.

The format is inspired by Keep a Changelog, and this project uses semantic versioning once public releases begin.

## [Unreleased]

### Added

- GitHub community files, contribution guide, release docs, issue templates, and CI workflow.

### Changed

- Project renamed to AudioPilot across public app metadata, SwiftPM targets, and Xcode project files.

## [0.1.0] - 2026-05-29

### Added

- Menu bar only macOS app.
- CoreAudio listener for default output device changes.
- Native UserNotifications alert when output changes.
- Current output device shown in the menu.
- Toggle for notifications.
- Optional speech of the device name, off by default.
- Launch at login toggle through `SMAppService`.
- App Sandbox with minimal entitlement.
- App icon and template menu bar icon.
- Basic tests for pure Swift logic.
