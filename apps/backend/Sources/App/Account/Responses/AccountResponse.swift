import Vapor

struct AccountResponse: Content {
    let id: UUID
    let name: String
    let email: String
}
