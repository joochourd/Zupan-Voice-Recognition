import Foundation
import Speech
import Combine

class SpeechRecognitionService {
    @Published var recognizedWords: [String] = []
    @Published var isRecording: Bool = false
    // Internal
    @Published private var _recognizedText: String = ""

    // External
    var recognizedText: AnyPublisher<String, Never> {
        return $_recognizedText.eraseToAnyPublisher()
    }

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?


    func startRecording() {
        isRecording = true
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                self?._recognizedText = result.bestTranscription.formattedString
                //self?.filterAndExecuteCommands()
            }
        }

        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    func stopRecording() {
        isRecording = false
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
    }

}
