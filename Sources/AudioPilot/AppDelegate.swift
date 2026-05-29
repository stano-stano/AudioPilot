import AppKit
#if SWIFT_PACKAGE
import AudioPilotCore
#endif

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let preferences = Preferences()
    private let monitor = AudioOutputMonitor()
    private let notificationService = NotificationService()
    private let speechService = SpeechService()
    private let loginItemService = LoginItemService()
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let menu = NSMenu()

    private var currentOutputDevice = AudioDeviceInfo.unavailable

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        currentOutputDevice = monitor.currentOutputDevice()
        configureStatusItem()
        rebuildMenu()

        if preferences.showNotifications {
            notificationService.requestAuthorizationIfNeeded()
        }

        monitor.onDefaultOutputDeviceChanged = { [weak self] device in
            self?.handleOutputDeviceChange(device)
        }

        do {
            try monitor.start()
        } catch {
            presentError(
                title: "Audio monitoring unavailable",
                message: error.localizedDescription
            )
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        try? monitor.stop()
    }

    private func configureStatusItem() {
        if let button = statusItem.button {
            button.toolTip = "AudioPilot"

            if let image = NSImage(named: "StatusBarIconTemplate") {
                image.isTemplate = true
                image.size = NSSize(width: 18, height: 18)
                button.image = image
            } else if let image = NSImage(
                systemSymbolName: "speaker.wave.2.fill",
                accessibilityDescription: "AudioPilot"
            ) {
                image.isTemplate = true
                button.image = image
            } else {
                button.title = "AudioPilot"
            }
        }

        statusItem.menu = menu
    }

    private func rebuildMenu() {
        menu.removeAllItems()

        let deviceItem = NSMenuItem(
            title: "Output: \(currentOutputDevice.displayName)",
            action: nil,
            keyEquivalent: ""
        )
        deviceItem.isEnabled = false
        menu.addItem(deviceItem)

        menu.addItem(.separator())

        let notificationItem = NSMenuItem(
            title: "Show notifications",
            action: #selector(toggleNotifications),
            keyEquivalent: ""
        )
        notificationItem.target = self
        notificationItem.state = preferences.showNotifications ? .on : .off
        menu.addItem(notificationItem)

        let speechItem = NSMenuItem(
            title: "Speak device name",
            action: #selector(toggleSpeech),
            keyEquivalent: ""
        )
        speechItem.target = self
        speechItem.state = preferences.speakDeviceName ? .on : .off
        menu.addItem(speechItem)

        let launchItem = NSMenuItem(
            title: "Launch at login",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchItem.target = self
        configureLaunchItemState(launchItem)
        menu.addItem(launchItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
    }

    private func configureLaunchItemState(_ item: NSMenuItem) {
        switch loginItemService.status {
        case .enabled:
            item.state = .on
            item.isEnabled = true
        case .disabled:
            item.state = .off
            item.isEnabled = true
        case .requiresApproval:
            item.state = .mixed
            item.isEnabled = true
        case .unavailable:
            item.state = .off
            item.isEnabled = false
        }
    }

    private func handleOutputDeviceChange(_ device: AudioDeviceInfo) {
        currentOutputDevice = device
        rebuildMenu()

        let displayName = device.displayName

        if preferences.showNotifications {
            notificationService.sendOutputChangedNotification(deviceName: displayName)
        }

        if preferences.speakDeviceName {
            speechService.speakDeviceName(displayName)
        }
    }

    @objc private func toggleNotifications() {
        preferences.showNotifications.toggle()

        if preferences.showNotifications {
            notificationService.requestAuthorizationIfNeeded()
        }

        rebuildMenu()
    }

    @objc private func toggleSpeech() {
        preferences.speakDeviceName.toggle()
        rebuildMenu()
    }

    @objc private func toggleLaunchAtLogin() {
        let shouldEnable = !loginItemService.isEnabled

        do {
            try loginItemService.setEnabled(shouldEnable)
        } catch {
            presentError(
                title: "Launch at login could not be changed",
                message: error.localizedDescription
            )
        }

        rebuildMenu()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    private func presentError(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.runModal()
    }
}
