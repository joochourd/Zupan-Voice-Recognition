import Foundation

enum Command: String, CaseIterable {
    case code
    case count
    case reset
    case back
}

enum RecognitionState {
    case waitingForCommand
    case listeningToCommand(Command)
}
