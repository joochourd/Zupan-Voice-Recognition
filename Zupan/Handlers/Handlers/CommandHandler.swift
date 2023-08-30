import Foundation

protocol CommandHandler {
    func respondsTo(_ commandName: String) -> Bool
    func execute(parameters: CommandParamaters, currentCommand: Command)
}
