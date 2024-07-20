import Vapor

struct FindAllAccountRequest: Content {
    let accounts: [AccountResponse]
}
