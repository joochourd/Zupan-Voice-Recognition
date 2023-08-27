import Foundation
import Speech
import Combine

class SpeechRecognitionViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isRecording: Bool = false
    // Array to hold the recognized words
    @Published var recognizedWords: [String] = []
    @Published var currentState: RecognitionState = .waitingForCommand



    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var previousRecognizedWords: [String] = []
    private var previousRecognizedWordCount: Int = 0
    private var accumulatedParameters: [Int] = []

    func startRecording() {
        isRecording = true
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                self?.recognizedText = result.bestTranscription.formattedString
                self?.filterAndExecuteCommands()
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


    // Function to filter and execute commands
    func filterAndExecuteCommands() {
        let currentRecognizedWords = recognizedText.split(separator: " ").map { String($0) }

        if currentRecognizedWords.count > previousRecognizedWordCount {
            if let lastWord = currentRecognizedWords.last {
                switch currentState {
                case .waitingForCommand:
                    if let commandEnum = Command(rawValue: lastWord.lowercased()) {
                        currentState = .listeningToCommand(commandEnum)
                    }
                case .listeningToCommand(let command):
                    executeCommand(command, withParameter: lastWord)
                }
            }

            previousRecognizedWordCount = currentRecognizedWords.count
        }
    }
    // Function to execute actions based on commands
    func executeCommand(_ command: Command, withParameter parameter: String) {
        print(command)
        var value: String?

        switch command {
        case .code, .count:
            if let number = Int(parameter), number >= 0 && number <= 9 {
                accumulatedParameters.append(number)
                value = accumulatedParameters.map { String($0) }.joined()
            }
        case .reset:
            currentState = .waitingForCommand
            accumulatedParameters.removeAll()
            value = "undefined"
        case .back:
            if !accumulatedParameters.isEmpty {
                accumulatedParameters.removeLast()
            }
            value = accumulatedParameters.isEmpty ? "undefined" : accumulatedParameters.map { String($0) }.joined()
        }

        if let value = value { print("Executed command: \(command), with value: \(value)") }
    }

}
