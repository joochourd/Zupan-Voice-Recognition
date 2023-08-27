import Foundation

class CommandsService {
    @Published var currentState: RecognitionState = .waitingForCommand
    private var previousRecognizedWords: [String] = []
    private var previousRecognizedWordCount: Int = 0
    private var accumulatedParameters: [Int] = []

    
    // Function to filter and execute commands
    func filterAndExecuteCommands(recognizedText: String) {
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
