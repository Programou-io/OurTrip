import Vapor

struct UpdateAccountResponse: Content, Equatable {
    let account: AccountResponse
    
    init(_ account: Account) {
        self.account = AccountResponse(account)
    }
}
