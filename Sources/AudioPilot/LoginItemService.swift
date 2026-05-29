import Foundation
import ServiceManagement

final class LoginItemService {
    enum Status {
        case enabled
        case disabled
        case requiresApproval
        case unavailable
    }

    var status: Status {
        switch SMAppService.mainApp.status {
        case .enabled:
            return .enabled
        case .requiresApproval:
            return .requiresApproval
        case .notRegistered:
            return .disabled
        case .notFound:
            return .unavailable
        @unknown default:
            return .unavailable
        }
    }

    var isEnabled: Bool {
        status == .enabled
    }

    func setEnabled(_ enabled: Bool) throws {
        if enabled {
            try SMAppService.mainApp.register()
        } else {
            try SMAppService.mainApp.unregister()
        }
    }
}
