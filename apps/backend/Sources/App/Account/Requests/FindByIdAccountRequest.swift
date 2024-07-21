import Vapor

struct FindByIdAccountRequest: Content {
    let account: AccountResponse
}
