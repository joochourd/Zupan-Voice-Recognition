import Foundation
import Speech
import Combine

class SpeechRecognitionViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isRecording: Bool = false
    @Published var commands: [Command] = []
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
        commands = commandsService.recognizeCommands(recognizedText: recognizedText)
//      Uncomment the following line to not have to speak through the test
//        commands = commandsService.recognizeCommands(recognizedText: "code 2 3 4 count 60 2 code 1 2 reset code 1 1 2 count 5 back")
        for command in commands {
            print("Command name: \(command.commandCode) and command value: \(command.commandValue)" )
        }
    }

    func startRecording() {
        print("Start")
        isRecording = true
        speechRecognitionService.startRecording()
    }
}
