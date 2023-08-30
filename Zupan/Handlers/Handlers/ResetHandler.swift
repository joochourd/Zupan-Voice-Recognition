import Foundation

class ResetHandler: CommandHandler {
    let commandName = "reset"
    func respondsTo(_ name: String) -> Bool { return name == commandName }

    func execute(parameters: CommandParamaters, currentCommand: Command) {
        parameters.lastCommand = nil
        parameters.accumulatedParameters = []
    }
}
