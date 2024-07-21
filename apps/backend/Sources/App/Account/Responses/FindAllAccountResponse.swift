import Vapor

struct FindAllAccountResponse: Content, Equatable {
    let accounts: [AccountResponse]
    
    init(_ accounts: [Account]) {
        self.accounts = accounts.map(AccountResponse.init)
    }
}
