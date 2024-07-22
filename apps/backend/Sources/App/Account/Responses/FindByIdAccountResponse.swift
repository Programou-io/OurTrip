import Vapor

struct FindByIdAccountResponse: Content {
    let account: AccountResponse
    
    init(_ account: Account) {
        self.account = AccountResponse(account)
    }
}
