import XCTest
#if SWIFT_PACKAGE
@testable import AudioPilotCore
#endif

final class PreferencesTests: XCTestCase {
    func testDefaultValues() {
        let suiteName = "app.audiopilot.tests.defaults.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let preferences = Preferences(userDefaults: defaults)

        XCTAssertTrue(preferences.showNotifications)
        XCTAssertFalse(preferences.speakDeviceName)
    }

    func testValuesPersistInUserDefaults() {
        let suiteName = "app.audiopilot.tests.persist.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let preferences = Preferences(userDefaults: defaults)
        preferences.showNotifications = false
        preferences.speakDeviceName = true

        let reloadedPreferences = Preferences(userDefaults: defaults)

        XCTAssertFalse(reloadedPreferences.showNotifications)
        XCTAssertTrue(reloadedPreferences.speakDeviceName)
    }
}
