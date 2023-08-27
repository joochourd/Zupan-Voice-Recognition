import Foundation
import Speech
import Combine

class SpeechRecognitionViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isRecording: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        speechRecognitionService
            .recognizedText
            .sink { [weak self] newText in
                self?.recognizedText = newText
            }
            .store(in: &cancellables)
     }




    let commandsService = CommandsService()
    let speechRecognitionService = SpeechRecognitionService()


    func stopRecording() {
        print("Stop")
        isRecording = false
        speechRecognitionService.stopRecording()
    }

    func startRecording() {
        print("Start")
        isRecording = true
        speechRecognitionService.startRecording()
    }
}
