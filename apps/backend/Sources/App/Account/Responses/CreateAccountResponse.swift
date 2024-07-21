import Vapor

struct CreateAccountResponse: Content, Equatable {
    let account: AccountResponse
    
    init(_ account: Account) {
        self.account = AccountResponse(account)
    }
}
