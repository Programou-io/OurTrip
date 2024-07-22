import Vapor

struct AccountController: RouteCollection, @unchecked Sendable {
    
    let accountRepository: AccountRepository

    func boot(routes: RoutesBuilder) throws {
        routes.post("accounts", use: createAccount)

        let secureRoute = routes.grouped(
            SessionToken.authenticator(),
            SessionToken.guardMiddleware()
        )
        let accountRoute = secureRoute.grouped("accounts")
        accountRoute.get(use: fetchAllAccounts)
        accountRoute.group(":accountId") {
            $0.get(use: findAccountById)
            $0.delete(use: deleteAccount)
            $0.patch(use: updateAccount)
        }
    }

    @Sendable private func fetchAllAccounts(request: Request) async throws -> Response {
        let accounts = try await accountRepository.findAll()

        let findAllAccountsResponse = FindAllAccountResponse(accounts)
        return try await findAllAccountsResponse.encodeResponse(for: request)
    }

    @Sendable private func findAccountById(request: Request) async throws -> Response {
        guard let token = try? request.auth.require(SessionToken.self) else {
            throw Abort(.unauthorized, reason: "Unauthorized")
        }

        guard let accountId = request.parameters.get("accountId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid account id path param")
        }

        guard token.accountId == accountId else {
            throw Abort(.unauthorized, reason: "Unauthorized")
        }

        guard let account = try await  accountRepository.findBy(id: accountId) else {
            throw Abort(.notFound, reason: "Resource not found")
        }

        let findByIdAccountResponse = FindByIdAccountResponse(account)
        return try await findByIdAccountResponse.encodeResponse(for: request)
    }

    @Sendable private func createAccount(request: Request) async throws -> Response {
        let createAccountRequest = try request.content.decode(CreateAccountRequest.self)

        if !createAccountRequest.email.isValidEmail {
            throw Abort(.badRequest, reason: "The 'email' field is invalid")
        }

        if !createAccountRequest.name.isValidName {
            throw Abort(.badRequest, reason: "The 'name' field is invalid")
        }

        if !createAccountRequest.password.isValidPassword {
            throw Abort(
                .badRequest,
                reason: """
                The 'password' field is invalid. It must contain:
                - at least 8 characters
                - at least 1 uppercase letter
                - at least 1 lowercase letter
                - at least 1 digit
                - at least 1 special character
                """
            )
        }

        let id = UUID()
        let hashedPassword = try await request.password.async.hash(createAccountRequest.password)
        let account = Account(
            id: id,
            name: createAccountRequest.name,
            email: createAccountRequest.email,
            password: hashedPassword
        )

        try await accountRepository.save(account)

        let createAccountResponse = CreateAccountResponse(account)
        return try await createAccountResponse.encodeResponse(status: .created, for: request)
    }

    @Sendable private func updateAccount(request: Request) async throws -> Response {
        guard let token = try? request.auth.require(SessionToken.self) else {
            throw Abort(.unauthorized, reason: "Unauthorized")
        }

        guard let accountId = request.parameters.get("accountId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid account id path param")
        }

        guard token.accountId == accountId else {
            throw Abort(.unauthorized, reason: "Unauthorized")
        }

        guard var account = try await accountRepository.findBy(id: accountId) else {
            throw Abort(.notFound, reason: "Resource not found")
        }

        let updateAccountRequest = try request.content.decode(UpdateAccountRequest.self)

        if let name = updateAccountRequest.name {
            account.name = name
        }

        if let email = updateAccountRequest.email {
            account.email = email
        }

        try await accountRepository.update(account)

        let updateAccountResponse = UpdateAccountResponse(account)
        return try await updateAccountResponse.encodeResponse(status: .ok, for: request)
    }

    @Sendable private func deleteAccount(request: Request) async throws -> Response {
        guard let token = try? request.auth.require(SessionToken.self) else {
            throw Abort(.unauthorized, reason: "Unauthorized")
        }

        guard let accountId = request.parameters.get("accountId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid account id path param")
        }

        guard token.accountId == accountId else {
            throw Abort(.unauthorized, reason: "Unauthorized")
        }

        guard let account = try await accountRepository.findBy(id: accountId) else {
            throw Abort(.notFound, reason: "Resource not found")
        }

        try await accountRepository.delete(account)

        return Response(status: .noContent)
    }
}
