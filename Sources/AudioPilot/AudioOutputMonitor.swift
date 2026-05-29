import CoreAudio
import Foundation
#if SWIFT_PACKAGE
import AudioPilotCore
#endif

enum AudioOutputMonitorError: LocalizedError {
    case listenerRegistrationFailed(OSStatus)
    case listenerRemovalFailed(OSStatus)

    var errorDescription: String? {
        switch self {
        case .listenerRegistrationFailed(let status):
            return "CoreAudio listener registration failed with status \(status)."
        case .listenerRemovalFailed(let status):
            return "CoreAudio listener removal failed with status \(status)."
        }
    }
}

final class AudioOutputMonitor {
    var onDefaultOutputDeviceChanged: ((AudioDeviceInfo) -> Void)?

    private let listenerQueue = DispatchQueue(label: "app.audiopilot.audio-output-listener")
    private lazy var debouncer = Debouncer(delay: 0.2, queue: listenerQueue)
    private var listenerBlock: AudioObjectPropertyListenerBlock?
    private var lastDevice: AudioDeviceInfo?
    private var isRunning = false

    func start() throws {
        guard !isRunning else {
            return
        }

        lastDevice = currentOutputDevice()

        let block: AudioObjectPropertyListenerBlock = { [weak self] _, _ in
            self?.defaultOutputDevicePropertyChanged()
        }

        var address = Self.defaultOutputDeviceAddress
        let status = AudioObjectAddPropertyListenerBlock(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            listenerQueue,
            block
        )

        guard status == noErr else {
            throw AudioOutputMonitorError.listenerRegistrationFailed(status)
        }

        listenerBlock = block
        isRunning = true
    }

    func stop() throws {
        guard isRunning, let listenerBlock else {
            return
        }

        debouncer.cancel()

        var address = Self.defaultOutputDeviceAddress
        let status = AudioObjectRemovePropertyListenerBlock(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            listenerQueue,
            listenerBlock
        )

        guard status == noErr else {
            throw AudioOutputMonitorError.listenerRemovalFailed(status)
        }

        self.listenerBlock = nil
        isRunning = false
    }

    func currentOutputDevice() -> AudioDeviceInfo {
        guard let deviceID = currentOutputDeviceID() else {
            return .unavailable
        }

        return AudioDeviceInfo(
            id: deviceID,
            name: outputDeviceName(for: deviceID),
            isAvailable: true
        )
    }

    private func defaultOutputDevicePropertyChanged() {
        debouncer.schedule { [weak self] in
            self?.publishChangedDeviceIfNeeded()
        }
    }

    private func publishChangedDeviceIfNeeded() {
        let device = currentOutputDevice()

        guard device != lastDevice else {
            return
        }

        lastDevice = device

        DispatchQueue.main.async { [weak self] in
            self?.onDefaultOutputDeviceChanged?(device)
        }
    }

    private func currentOutputDeviceID() -> AudioDeviceID? {
        var deviceID = AudioDeviceID(kAudioObjectUnknown)
        var size = UInt32(MemoryLayout<AudioDeviceID>.size)
        var address = Self.defaultOutputDeviceAddress

        let status = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            0,
            nil,
            &size,
            &deviceID
        )

        guard status == noErr, deviceID != kAudioObjectUnknown else {
            return nil
        }

        return deviceID
    }

    private func outputDeviceName(for deviceID: AudioDeviceID) -> String? {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        guard AudioObjectHasProperty(deviceID, &address) else {
            return nil
        }

        var name: CFString?
        var size = UInt32(MemoryLayout<CFString?>.size)

        let status = withUnsafeMutablePointer(to: &name) { namePointer in
            AudioObjectGetPropertyData(
                deviceID,
                &address,
                0,
                nil,
                &size,
                namePointer
            )
        }

        guard status == noErr, let name else {
            return nil
        }

        return name as String
    }

    private static var defaultOutputDeviceAddress: AudioObjectPropertyAddress {
        AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
    }
}
