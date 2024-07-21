import Foundation

struct MissingEnvironmentVaribleError: Error {
    private let missedVariable: String
    
    
    init(_ key: String) {
        self.missedVariable = "Missing value for environment key '\(key)'"
    }
    
    var localizedDescription: String {
        missedVariable
    }
}
