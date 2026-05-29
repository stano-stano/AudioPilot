import CoreAudio
import Foundation

public struct AudioDeviceInfo: Equatable {
    public let id: AudioDeviceID?
    public let name: String?
    public let isAvailable: Bool

    public static let unavailable = AudioDeviceInfo(id: nil, name: nil, isAvailable: false)

    public init(id: AudioDeviceID?, name: String?, isAvailable: Bool) {
        self.id = id
        self.name = name
        self.isAvailable = isAvailable
    }

    public var displayName: String {
        let cleanedName = name?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let cleanedName, !cleanedName.isEmpty {
            return cleanedName
        }

        return isAvailable ? "Unknown output device" : "No output device"
    }
}
