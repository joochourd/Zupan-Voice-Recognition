import Foundation

class CommandsService {
    var lastCommand: Command?
    var accumulatedParameters: [Int] = []
    var accumulatedCommands: [Command] = []

    func recognizeCommands(recognizedText: String) -> [Command] {
        reset()
        let currentRecognizedWords = recognizedText.split(separator: " ").map { String($0).lowercased() }

        for word in currentRecognizedWords {
            if let parameter = getParamaterFrom(word) {
                handleParameter(parameter)
            }
            if let command = getCommandFrom(word) {
                handleCommand(command)
            }
            // If none, then ignore word
        }
        return accumulatedCommands
    }

    private func handleParameter(_ paramter: Int) {
        if lastCommand != nil {
            accumulatedParameters.append(paramter)
        }
    }

    private func getCommandFrom(_ word: String) -> Command? {
        if let command = Command(commandCode: word) { return command }
        return nil
    }

    private func getParamaterFrom(_ word: String) -> Int? {
        if let parameter = Int(word), parameter >= 0 && parameter <= 9 {
            return parameter
        }
        return nil
    }

    private func handleCommand(_ command: Command) {
        switch command.commandCode {
        case .code, .count:
            saveLastCommand(command)
            lastCommand = command
        case .reset:
            lastCommand = nil
            accumulatedParameters = []
        case .back:
            saveLastCommand(command)
            lastCommand = nil
            accumulatedParameters = []
            accumulatedCommands.removeLast()

        }
    }

    private func saveLastCommand(_ command: Command) {
        //if last command is found and values are stored, then save that command
        if var command = lastCommand, !accumulatedParameters.isEmpty {
            command.commandValue = accumulatedParameters.map { String($0) }.joined()
            accumulatedCommands.append(command)
            lastCommand = nil
            accumulatedParameters = []
        }

    }
    private func reset() {
        lastCommand = nil
        accumulatedParameters = []
        accumulatedCommands = []
    }
}
