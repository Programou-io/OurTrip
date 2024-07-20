import Vapor

struct CreateAccountRequest: Content {
    let name: String
    let email: String
    let password: String
}

