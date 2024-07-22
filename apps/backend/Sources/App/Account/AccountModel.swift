import Foundation
import Vapor
import Fluent

struct Account {
    let id: UUID
    var name: String
    var email: String
    var password: String
}
