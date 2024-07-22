@testable import App
import XCTVapor
import Fluent

final class AccountsTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        try await configure(app)
        try await app.autoMigrate()
    }

    override func tearDown() async throws {
        try await app.autoRevert()
        try await app.asyncShutdown()
        app = nil
    }
    
    func testCreateAccountWithValidCredentialsReturnsCreatedStatus() async throws {
        let newAccount = makeCreateAccountRequestModel()
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(CreateAccountRequest(name: newAccount.name, email: newAccount.email, password: newAccount.password))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .created)
            let response = try res.content.decode(CreateAccountResponse.self)
            XCTAssertEqual(response.account.email, newAccount.email)
            XCTAssertEqual(response.account.name, newAccount.name)
        })
    }
    
    func testCreateAccountWithInvalidNameReturnsBadRequest() async throws {
        let invalidAccount = makeCreateAccountRequestModel(name: "a")
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(CreateAccountRequest(name: invalidAccount.name, email: invalidAccount.email, password: invalidAccount.password))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "The 'name' field is invalid")
        })
    }
    
    func testCreateAccountWithInvalidEmailFormatReturnsBadRequest() async throws {
        let invalidAccount = makeCreateAccountRequestModel(email: "invalid email")
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(CreateAccountRequest(name: invalidAccount.name, email: invalidAccount.email, password: invalidAccount.password))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "The 'email' field is invalid")
        })
    }
    
    func testCreateAccountWithInvalidPasswordFormatReturnsBadRequest() async throws {
        let invalidAccount = makeCreateAccountRequestModel(password: "invalid password")
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(CreateAccountRequest(name: invalidAccount.name, email: invalidAccount.email, password: invalidAccount.password))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, """
            The 'password' field is invalid. It must contain:
            - at least 8 characters
            - at least 1 uppercase letter
            - at least 1 lowercase letter
            - at least 1 digit
            - at least 1 special character
            """)
        })
    }
    
    func testFetchAllAccountsWithoutTokenReturnsUnauthorized() async throws {
        try await app.test(.GET, "accounts", afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testFetchAllAccountsWithValidTokenReturnsAccounts() async throws {
        let account = makeCreateAccountRequestModel()
        try await performRequestToCreateNewAccount(account: account)
        try await performRequestToCreateNewAccount(account: makeCreateAccountRequestModel())
        try await performRequestToCreateNewAccount(account: makeCreateAccountRequestModel())
        
        let authResponse = try await performRequestToAuthenticateWith(account: account)
        
        let headers = HTTPHeaders([makeAuthorizationHeader(authentication: authResponse)])
        try await app.test(.GET, "accounts", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            let findAllResponse = try res.content.decode(FindAllAccountResponse.self)
            XCTAssertEqual(findAllResponse.accounts.count, 3)
        })
    }
    
    func testRetrieveAccountWithoutTokenReturnsUnauthorized() async throws {
        try await app.test(.GET, "accounts/\(UUID().uuidString)", afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testRetrieveAccountWithValidTokenButUnauthorizedIdReturnsUnauthorized() async throws {
        let account = makeCreateAccountRequestModel()
        try await performRequestToCreateNewAccount(account: account)
        var otherAccount: CreateAccountResponse!
        otherAccount = try await performRequestToCreateNewAccount(account: makeCreateAccountRequestModel())
        
        let authResponse = try await performRequestToAuthenticateWith(account: account)
        
        let headers = HTTPHeaders([makeAuthorizationHeader(authentication: authResponse)])
        try await app.test(.GET, "accounts/\(otherAccount.account.id)", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "Unauthorized")
        })
    }
    
    func testRetrieveAccountWithValidTokenAndValidIdReturnsAccount() async throws {
        let account = makeCreateAccountRequestModel()
        let createdAccount = try await performRequestToCreateNewAccount(account: account)
        
        let authResponse = try await performRequestToAuthenticateWith(account: account)
        
        let headers = HTTPHeaders([makeAuthorizationHeader(authentication: authResponse)])
        try await app.test(.GET, "accounts/\(createdAccount.account.id)", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(FindByIdAccountResponse.self)
            XCTAssertEqual(response.account.email, account.email)
            XCTAssertEqual(response.account.name, account.name)
            XCTAssertEqual(response.account.id, createdAccount.account.id)
        })
    }
    
    func testUpdateAccountWithoutTokenReturnsUnauthorized() async throws {
        let createdAccount = try await performRequestToCreateNewAccount(account: makeCreateAccountRequestModel())
        
        try await app.test(.PATCH, "accounts/\(createdAccount.account.id)", beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: "Other Name", email: "Other Email"))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testUpdateAccountWithValidTokenReturnsUpdatedAccount() async throws {
        let account = makeCreateAccountRequestModel()
        let createdAccount = try await performRequestToCreateNewAccount(account: account)
        
        let authResponse = try await performRequestToAuthenticateWith(account: account)
        
        let newName = "Updated Name"
        let newEmail = "updated.email@example.com"
        let headers = HTTPHeaders([makeAuthorizationHeader(authentication: authResponse)])
        try await app.test(.PATCH, "accounts/\(createdAccount.account.id)", headers: headers, beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: newName, email: newEmail))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(UpdateAccountResponse.self)
            XCTAssertEqual(response.account.id, createdAccount.account.id)
            XCTAssertEqual(response.account.email, newEmail)
            XCTAssertEqual(response.account.name, newName)
        })
    }
    
    func testDeleteAccountWithoutTokenReturnsUnauthorized() async throws {
        let createdAccount = try await performRequestToCreateNewAccount(account: makeCreateAccountRequestModel())
        
        try await app.test(.DELETE, "accounts/\(createdAccount.account.id)", beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: "Other Name", email: "Other Email"))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testDeleteAccountWithInvalidIdReturnsUnauthorized() async throws {
        let account = makeCreateAccountRequestModel()
        try await performRequestToCreateNewAccount(account: account)
        
        let authResponse = try await performRequestToAuthenticateWith(account: account)
        
        let headers = HTTPHeaders([makeAuthorizationHeader(authentication: authResponse)])
        try await app.test(.DELETE, "accounts/\(UUID().uuidString)", headers: headers, beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: "Other Name", email: "Other Email"))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
            let errorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(errorResponse.error)
            XCTAssertEqual(errorResponse.reason, "Unauthorized")
        })
    }
    
    func testDeleteAccountWithValidTokenAndValidIdReturnsNoContent() async throws {
        let account = makeCreateAccountRequestModel()
        let createdAccount = try await performRequestToCreateNewAccount(account: account)
        
        let authResponse = try await performRequestToAuthenticateWith(account: account)
        
        let headers = HTTPHeaders([makeAuthorizationHeader(authentication: authResponse)])
        try await app.test(.DELETE, "accounts/\(createdAccount.account.id)", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .noContent)
        })
    }
    
    @discardableResult
    private func performRequestToCreateNewAccount(account: CreateAccountRequest) async throws -> CreateAccountResponse {
        var response: CreateAccountResponse!
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(account)
        }, afterResponse: { res in
            response = try res.content.decode(CreateAccountResponse.self)
        })
        return response
    }
    
    private func performRequestToAuthenticateWith(account: CreateAccountRequest) async throws -> AuthenticationResponse {
        var response: AuthenticationResponse!
        try await app.test(.POST, "authentication", beforeRequest: { req async throws in
            try req.content.encode(AuthenticationRequest(email: account.email, password: account.password))
        }, afterResponse: { res in
            response = try res.content.decode(AuthenticationResponse.self)
        })
        return response
    }
    
    private func makeCreateAccountRequestModel(name: String = "John", email: String = "jhondoe@mail.com", password: String = "@Strong4Password") -> CreateAccountRequest {
        CreateAccountRequest(name: name, email: email, password: password)
    }
    
    private func makeAuthorizationHeader(authentication response: AuthenticationResponse) -> (String, String) {
        ("Authorization", "Bearer \(response.token)")
    }
}


struct AbortErrorResponse: Content {
    let reason: String
    let error: Bool
}
