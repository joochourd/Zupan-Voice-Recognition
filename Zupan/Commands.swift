import Foundation

struct Command {
    let id = UUID()
    let commandCode: CommandCode
    var commandValue: String?

    init?(commandCode: String, commandValue: String? = nil) {
        guard let commandCode = CommandCode(rawValue: commandCode)  else { return nil }
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

enum CommandCode: String {
    case code
    case count
    case reset
    case back
}
