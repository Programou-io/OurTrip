import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { _ in "Wellcome to Our Trip" }

    let accountRepository = InMemoryAccountRepositoryAdapter()
    try app.register(collection: AuthenticationController(accountRepository: accountRepository))
    try app.register(collection: AccountController(accountRepository: accountRepository))
}
