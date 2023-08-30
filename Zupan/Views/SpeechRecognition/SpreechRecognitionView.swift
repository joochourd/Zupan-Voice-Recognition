import SwiftUI

struct SpreechRecognitionView: View {
    @ObservedObject var viewModel = SpeechRecognitionViewModel()

    var body: some View {
        VStack {
            Text(viewModel.recognizedText)
                .padding()
                .multilineTextAlignment(.center)

            Button(action: {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                } else {
                    viewModel.startRecording()
                }
            }) {
                Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.isRecording ? Color.red : Color.blue)
                    .cornerRadius(8)
            }
            // Dynamic list of commands
            List {
                ForEach(viewModel.commands, id: \.self) { command in
                    HStack {
                        Text("Command: \(command.commandCode.rawValue)")
                        Spacer()
                        Text("Value: \(command.commandValue ?? "")")
                    }
                }
            }
        }
    }
    
}
