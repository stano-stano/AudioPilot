import AppKit

final class SpeechService {
    private let synthesizer = NSSpeechSynthesizer()

    func speakDeviceName(_ deviceName: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking()
        }

        synthesizer.startSpeaking(deviceName)
    }
}
