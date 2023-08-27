import Foundation

class Command {
    var id = UUID()
    var commandCode: String
    var commandValue: String?
    var possibleCommands = ["code","count","reset","back"]

    init?(commandCode: String, commandValue: String? = nil) {
        if !possibleCommands.contains(commandCode) {
            return nil
        }

        self.commandCode = commandCode
        self.commandValue = commandValue
    }
}

enum RecognitionState {
    case waitingForCommand
    case listeningToCommand(Command)
}

extension Command: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Command, rhs: Command) -> Bool {
        lhs.id == rhs.id
    }
}
