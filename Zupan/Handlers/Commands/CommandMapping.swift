import Foundation

func loadCommandMappings() -> [String: [String: String]]? {
    if let url = Bundle.main.url(forResource: "CommandMappings", withExtension: "json"),
       let data = try? Data(contentsOf: url),
       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: String]] {
        return json
    }
    return nil
}
