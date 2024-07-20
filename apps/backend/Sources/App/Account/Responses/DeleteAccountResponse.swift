import Vapor

struct DeleteAccountResponse: Content {
    let account: AccountResponse
}
