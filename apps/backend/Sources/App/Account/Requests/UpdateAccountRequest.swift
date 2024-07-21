import Vapor

struct UpdateAccountRequest: Content {
    var name: String?
    var email: String?
}
