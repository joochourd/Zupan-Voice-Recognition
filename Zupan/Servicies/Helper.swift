import Foundation

class Helper {
    
    static let shared = Helper()

    func getLocale() -> Locale {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en_US"
        return Locale(identifier: savedLanguage)
    }

}

