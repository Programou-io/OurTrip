import Vapor

struct CreateAccountResponse: Content {
    let account: AccountResponse
}
