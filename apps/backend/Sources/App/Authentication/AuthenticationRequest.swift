import Vapor

struct AuthenticationRequest: Content {
    let email: String
    let password: String
}
