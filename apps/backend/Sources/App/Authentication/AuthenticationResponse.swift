import Vapor

struct AuthenticationResponse: Content {
    let token: String
}
