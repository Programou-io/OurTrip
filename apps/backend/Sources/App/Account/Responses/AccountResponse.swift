import Vapor

struct AccountResponse: Content, Equatable {
    let id: UUID
    let name: String
    let email: String
    
    init(_ account: Account) {
        id = account.id
        name = account.name
        email = account.email
    }
}
