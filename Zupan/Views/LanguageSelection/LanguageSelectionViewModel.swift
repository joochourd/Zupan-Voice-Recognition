import SwiftUI
import Combine

class LanguageSelectionViewModel: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        }
    }

    let availableLanguages = [
        "en_US": "English (United States)",
        "es_ES": "Spanish (Spain)",
        "fr_FR": "French (France)",
        "de_DE": "German (Germany)",
        "it_IT": "Italian (Italy)",
        "pt_BR": "Portuguese (Brazil)"
        // Add more languages here
    ]

    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            selectedLanguage = savedLanguage
        } else {
            selectedLanguage = "en_US" // Default to English (United States)
        }
    }

    func proceedToApp() {
        print("Proceeding with selected language: \(selectedLanguage)")
    }
}
