import Vapor

struct UpdateAccountRequest: Content {
    var name: String? = nil
    var email: String? = nil
}
