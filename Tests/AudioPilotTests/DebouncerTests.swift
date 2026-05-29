import XCTest
#if SWIFT_PACKAGE
@testable import AudioPilotCore
#endif

final class DebouncerTests: XCTestCase {
    func testDebouncerRunsOnlyMostRecentAction() {
        let queue = DispatchQueue(label: "app.audiopilot.tests.debouncer")
        let debouncer = Debouncer(delay: 0.05, queue: queue)
        let expectation = expectation(description: "Latest debounced action ran")
        let lock = NSLock()
        var values: [Int] = []

        debouncer.schedule {
            lock.lock()
            values.append(1)
            lock.unlock()
        }

        debouncer.schedule {
            lock.lock()
            values.append(2)
            lock.unlock()
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        lock.lock()
        let capturedValues = values
        lock.unlock()

        XCTAssertEqual(capturedValues, [2])
    }

    func testCancelPreventsScheduledAction() {
        let queue = DispatchQueue(label: "app.audiopilot.tests.debouncer.cancel")
        let debouncer = Debouncer(delay: 0.05, queue: queue)
        let expectation = expectation(description: "Cancelled action did not run")
        expectation.isInverted = true

        debouncer.schedule {
            expectation.fulfill()
        }
        debouncer.cancel()

        wait(for: [expectation], timeout: 0.2)
    }
}
