import XCTest
#if SWIFT_PACKAGE
@testable import AudioPilotCore
#endif

final class AudioDeviceInfoTests: XCTestCase {
    func testDisplayNameUsesCleanName() {
        let device = AudioDeviceInfo(id: 42, name: "  AirPods Pro  ", isAvailable: true)

        XCTAssertEqual(device.displayName, "AirPods Pro")
    }

    func testDisplayNameFallsBackForUnnamedAvailableDevice() {
        let device = AudioDeviceInfo(id: 42, name: " ", isAvailable: true)

        XCTAssertEqual(device.displayName, "Unknown output device")
    }

    func testDisplayNameFallsBackWhenNoDeviceIsAvailable() {
        XCTAssertEqual(AudioDeviceInfo.unavailable.displayName, "No output device")
    }
}
