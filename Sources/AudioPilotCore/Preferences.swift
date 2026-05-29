import Foundation

public final class Preferences {
    private enum Key {
        static let showNotifications = "showNotifications"
        static let speakDeviceName = "speakDeviceName"
    }

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [
            Key.showNotifications: true,
            Key.speakDeviceName: false
        ])
    }

    public var showNotifications: Bool {
        get {
            userDefaults.bool(forKey: Key.showNotifications)
        }
        set {
            userDefaults.set(newValue, forKey: Key.showNotifications)
        }
    }

    public var speakDeviceName: Bool {
        get {
            userDefaults.bool(forKey: Key.speakDeviceName)
        }
        set {
            userDefaults.set(newValue, forKey: Key.speakDeviceName)
        }
    }
}
