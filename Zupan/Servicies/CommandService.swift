import Foundation

class CommandsService {
    var commandParamter = CommandParamaters()
    let mappings = loadCommandMappings()
    let currentLocale = Helper.shared.getLocale().identifier
    let commandHandlers: [CommandHandler] = [ResetHandler(), CodeHandler(), CountHandler(), BackHandler()]

    func recognizeCommands(recognizedText: String) -> [Command] {
        reset()
        let currentRecognizedWords: [String] = recognizedText
            .split(separator: " ")
            .map { String($0).lowercased() }
            .map { getInternalCommandName($0, locale: currentLocale)}

        for word in currentRecognizedWords {
            if let parameter = getParamaterFrom(word) {
                handleParameter(parameter)
            }
            if let command = getCommandFrom(word) {
                handleCommand(command)
            }
            // If none, then ignore word
        }
        saveLastCommand()
        return commandParamter.accumulatedCommands
    }

    private func handleParameter(_ paramter: Int) {
        if commandParamter.lastCommand != nil {
            commandParamter.accumulatedParameters.append(paramter)
        }
    }

    private func getCommandFrom(_ word: String) -> Command? {
        if let command = Command(commandCode: word) { return command }
        return nil
    }

    private func getParamaterFrom(_ word: String) -> Int? {
        if let parameter = Int(word) { //, parameter >= 0 && parameter <= 9 {
            return parameter
        }
        return nil
    }

    private func handleCommand(_ command: Command) {
        for commandHandler in commandHandlers {
            if commandHandler.respondsTo(command.commandCode.rawValue) {
                commandHandler.execute(parameters: commandParamter, currentCommand: command)
            }
        }
    }

    private func reset() {
        commandParamter.lastCommand = nil
        commandParamter.accumulatedParameters = []
        commandParamter.accumulatedCommands = []
    }

    private func getInternalCommandName(_ recognizedCommand: String, locale: String) -> String {
        return mappings?[locale]?[recognizedCommand] ?? recognizedCommand
    }

    private func saveLastCommand() {
        if var command = commandParamter.lastCommand, !commandParamter.accumulatedParameters.isEmpty {
            command.commandValue = commandParamter.accumulatedParameters.map { String($0) }.joined()
            commandParamter.accumulatedCommands.append(command)
            commandParamter.lastCommand = nil
            commandParamter.accumulatedParameters = []
        }
    }
        
}
