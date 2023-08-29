import SwiftUI

struct LanguageSelectionView: View {
    @ObservedObject var viewModel = LanguageSelectionViewModel()
    @State private var navigateToNextView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(Array(viewModel.availableLanguages.keys), id: \.self) { key in
                        HStack {
                            Text(viewModel.availableLanguages[key] ?? "")
                            Spacer()
                            if key == viewModel.selectedLanguage {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedLanguage = key
                        }
                    }
                }

                NavigationLink("", destination: SpreechRecognitionView(), isActive: $navigateToNextView)
                    .hidden()

                Button("Proceed to App") {
                    viewModel.proceedToApp()
                    navigateToNextView = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .navigationBarTitle("Select Language", displayMode: .inline)
        }
    }
}
