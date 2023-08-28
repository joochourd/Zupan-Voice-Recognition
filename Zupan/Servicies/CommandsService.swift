import Foundation

class CommandsService {
    @Published var currentState: RecognitionState = .waitingForCommand
    private var previousRecognizedWords: [String] = []
    private var previousRecognizedWordCount: Int = 0
    private var accumulatedParameters: [Int] = []
    private var recognizedCommands: [Command] = []

    
    enum RecognitionState {
        case waitingForCommand
        case listeningToCommand(Command)
    }

    // Function to filter and execute commands
    private func reset() {
        previousRecognizedWords = []
        previousRecognizedWordCount = 0
        accumulatedParameters = []
        recognizedCommands = []
    }
    func filterAndExecuteCommands(recognizedText: String) -> [Command] {
        reset()
        let currentRecognizedWords = recognizedText.split(separator: " ").map { String($0).lowercased() }

        for word in currentRecognizedWords {
            switch currentState {
            case .waitingForCommand:
                if let command = Command(commandCode: word) {
                    currentState = .listeningToCommand(command)
                    accumulatedParameters.removeAll()
                }
            case .listeningToCommand(let command):
                if let number = Int(word){ //, number >= 0 && number <= 9 {
                    accumulatedParameters.append(number)
                } else if let newCommand = Command(commandCode: word) {
                    // Save the previous command and its parameters
                    command.commandValue = accumulatedParameters.map { String($0) }.joined()
                    recognizedCommands.append(command)

                    // Reset for the new command
                    currentState = .listeningToCommand(newCommand)
                    accumulatedParameters.removeAll()
                }
            }
        }

        // Save the last command and its parameters, if any
        if case .listeningToCommand(let command) = currentState {
            command.commandValue = accumulatedParameters.map { String($0) }.joined()
            recognizedCommands.append(command)
        }

        currentState = .waitingForCommand
        return recognizedCommands
    }

    
    // Function to execute actions based on commands
    func executeCommand(_ command: Command, withParameter parameter: String) {
        print(command)
        var value: String?

        switch command.commandValue {
        case "code", "count":
            if let number = Int(parameter), number >= 0 && number <= 9 {
                accumulatedParameters.append(number)
                value = accumulatedParameters.map { String($0) }.joined()
            }
        case "reset":
            currentState = .waitingForCommand
            accumulatedParameters.removeAll()
            value = "undefined"
        case "back":
            if !accumulatedParameters.isEmpty {
                accumulatedParameters.removeLast()
            }
            value = accumulatedParameters.isEmpty ? "undefined" : accumulatedParameters.map { String($0) }.joined()
        default:
            break
        }

        if let value = value { print("Executed command: \(command), with value: \(value)") }
    }
}
