import Foundation

class CodeHandler: CommandHandler {
    let commandName = "code"
    func respondsTo(_ name: String) -> Bool { return name == commandName }

    func execute(parameters: CommandParamaters, currentCommand: Command) {
        //if last command is found and values are stored, then save that command
        if var command = parameters.lastCommand, !parameters.accumulatedParameters.isEmpty {
            command.commandValue = parameters.accumulatedParameters.map { String($0) }.joined()
            parameters.accumulatedCommands.append(command)
            parameters.lastCommand = nil
            parameters.accumulatedParameters = []
        }
        parameters.lastCommand = currentCommand
    }
}
