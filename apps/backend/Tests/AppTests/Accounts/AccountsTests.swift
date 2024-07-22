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
    
    func testCreateNewAccountWithValidCredentials() async throws {
        let newAccount = makeAccount()
        try await app.test(.POST, "accounts", beforeRequest: { request in
            let createAccountRequest = makeCreateAccountRequestModel(newAccount)
            try request.content.encode(createAccountRequest)
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .created)
            let response = try res.content.decode(CreateAccountResponse.self)
            XCTAssertEqual(response.account.email, newAccount.email)
            XCTAssertEqual(response.account.name, newAccount.name)
        })
    }
    
    func testCreateAccountWithInvalidName() async throws {
        let newAccount = makeAccount(name: "a")
        try await app.test(.POST, "accounts", beforeRequest: { request in
            let createAccountRequest = makeCreateAccountRequestModel(newAccount)
            try request.content.encode(createAccountRequest)
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .badRequest)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "The 'name' field is invalid")
        })
    }
    
    func testCreateAccountWithInvalidEmailFormat() async throws {
        let newAccount = makeAccount(email: "any invalid email")
        try await app.test(.POST, "accounts", beforeRequest: { request in
            let createAccountRequest = makeCreateAccountRequestModel(newAccount)
            try request.content.encode(createAccountRequest)
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .badRequest)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "The 'email' field is invalid")
        })
    }
    
    func testCreateAccountWithInvalidPasswordFormat() async throws {
        let newAccount = makeAccount(password: "invalid password")
        try await app.test(.POST, "accounts", beforeRequest: { request in
            let createAccountRequest = makeCreateAccountRequestModel(newAccount)
            try request.content.encode(createAccountRequest)
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .badRequest)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, """
            The 'password' field is invalid. It must contain:
            - at least 8 characters
            - at least 1 uppercase letter
            - at least 1 lowercase letter
            - at least 1 digit
            - at least 1 special character
            """)
        })
    }
    
    func testFetchAllAccountsWithoutTokenShouldRespondWithUnauthorizedState() async throws {
        try await app.test(.GET, "accounts", afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testFetchAllAccountsWhenAuthenticatedButWithAccountsToRetrieve() async throws {
        let account = makeAccount()
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(account))
        })
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(makeAccount()))
        })
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(makeAccount()))
        })
        
        var authenticationResponse: AuthenticationResponse!
        try await app.test(.POST, "authentication", beforeRequest: { req async throws in
            try req.content.encode(AuthenticationRequest(email: account.email, password: account.password))
        }, afterResponse: { response async throws in
            authenticationResponse = try response.content.decode(AuthenticationResponse.self)
        })
        
        let headers = HTTPHeaders([("Authorization", "Bearer \(authenticationResponse.token)")])
        try await app.test(.GET, "accounts", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            let findAllAccountResponse = try res.content.decode(FindAllAccountResponse.self)
            XCTAssertEqual(findAllAccountResponse.accounts.count, 3)
        })
    }
    
    func testRetrieveAccountWithoutAuthentication() async throws {
        try await app.test(.GET, "accounts/\(UUID().uuidString)", afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testRetrieveAccountWith() async throws {
        let account = makeAccount()
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(account))
        })
        var otherAccountCreated: CreateAccountResponse!
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(account))
        }, afterResponse: { resp async throws in
            otherAccountCreated = try resp.content.decode(CreateAccountResponse.self)
        })
        
        var authenticationResponse: AuthenticationResponse!
        try await app.test(.POST, "authentication", beforeRequest: { req async throws in
            try req.content.encode(AuthenticationRequest(email: account.email, password: account.password))
        }, afterResponse: { response async throws in
            authenticationResponse = try response.content.decode(AuthenticationResponse.self)
        })
        
        let headers = HTTPHeaders([("Authorization", "Bearer \(authenticationResponse.token)")])
        try await app.test(.GET, "accounts/\(otherAccountCreated.account.id)", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "Unauthorized")
        })
    }
    
    func testRetrieveAccountWithValidId() async throws {
        let account = makeAccount()
        var createdAccount: CreateAccountResponse!
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(account))
        }, afterResponse: { resp async throws in
            createdAccount = try resp.content.decode(CreateAccountResponse.self)
        })
        
        var authenticationResponse: AuthenticationResponse!
        try await app.test(.POST, "authentication", beforeRequest: { req async throws in
            try req.content.encode(AuthenticationRequest(email: account.email, password: account.password))
        }, afterResponse: { response async throws in
            authenticationResponse = try response.content.decode(AuthenticationResponse.self)
        })
        
        let headers = HTTPHeaders([("Authorization", "Bearer \(authenticationResponse.token)")])
        try await app.test(.GET, "accounts/\(createdAccount.account.id)", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            let getAccountResponse = try res.content.decode(FindByIdAccountRequest.self)
            XCTAssertEqual(getAccountResponse.account.email, account.email)
            XCTAssertEqual(getAccountResponse.account.name, account.name)
            XCTAssertEqual(getAccountResponse.account.id, createdAccount.account.id)
        })
    }
    
    func testUpdateWithoutAuthorization() async throws {
        var createdAccount: CreateAccountResponse!
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(makeAccount()))
        }, afterResponse: { resp async throws in
            createdAccount = try resp.content.decode(CreateAccountResponse.self)
        })
        
        try await app.test(.PATCH, "accounts/\(createdAccount.account.id)", beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: "Other Name", email: "Other Email"))
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testUpdateWithoutAuthorized() async throws {
        let account = makeAccount()
        var createdAccount: CreateAccountResponse!
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(account))
        }, afterResponse: { resp async throws in
            createdAccount = try resp.content.decode(CreateAccountResponse.self)
        })
        
        var authenticationResponse: AuthenticationResponse!
        try await app.test(.POST, "authentication", beforeRequest: { req async throws in
            try req.content.encode(AuthenticationRequest(
                email: account.email,
                password: account.password
            ))
        }, afterResponse: { response async throws in
            authenticationResponse = try response.content.decode(AuthenticationResponse.self)
        })
        
        let newName = "Other new name"
        let newEmail = "Other new email"
        let headers = HTTPHeaders([("Authorization", "Bearer \(authenticationResponse.token)")])
        try await app.test(.PATCH, "accounts/\(createdAccount.account.id)", headers: headers, beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: newName, email: newEmail))
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            let updateAccountReponse = try res.content.decode(UpdateAccountResponse.self)
            XCTAssertEqual(updateAccountReponse.account.id, createdAccount.account.id)
            XCTAssertEqual(updateAccountReponse.account.email, newEmail)
            XCTAssertEqual(updateAccountReponse.account.name, newName)
        })
    }
    
    func testDeleteWithoutAuthorization() async throws {
        var createdAccount: CreateAccountResponse!
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(makeAccount()))
        }, afterResponse: { resp async throws in
            createdAccount = try resp.content.decode(CreateAccountResponse.self)
        })
        
        try await app.test(.DELETE, "accounts/\(createdAccount.account.id)", beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: "Other Name", email: "Other Email"))
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "SessionToken not authenticated.")
        })
    }
    
    func testDeleteWithoutWithoutInvalidId() async throws {
        let account = makeAccount()
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(account))
        })
        
        var authenticationResponse: AuthenticationResponse!
        try await app.test(.POST, "authentication", beforeRequest: { req async throws in
            try req.content.encode(AuthenticationRequest(
                email: account.email,
                password: account.password
            ))
        }, afterResponse: { response async throws in
            authenticationResponse = try response.content.decode(AuthenticationResponse.self)
        })
        
        let headers = HTTPHeaders([("Authorization", "Bearer \(authenticationResponse.token)")])
        try await app.test(.DELETE, "accounts/\(UUID().uuidString)", headers: headers, beforeRequest: { req async throws in
            try req.content.encode(UpdateAccountRequest(name: "Other Name", email: "Other Email"))
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .unauthorized)
            let abortErrorResponse = try res.content.decode(AbortErrorResponse.self)
            XCTAssertTrue(abortErrorResponse.error)
            XCTAssertEqual(abortErrorResponse.reason, "Unauthorized")
        })
    }
    
    func testDeleteWithoutWithoutValidId() async throws {
        let account = makeAccount()
        var createdAccount: CreateAccountResponse!
        try await app.test(.POST, "accounts", beforeRequest: { req async throws in
            try req.content.encode(makeCreateAccountRequestModel(account))
        }, afterResponse: { resp async throws in
            createdAccount = try resp.content.decode(CreateAccountResponse.self)
        })
        
        var authenticationResponse: AuthenticationResponse!
        try await app.test(.POST, "authentication", beforeRequest: { req async throws in
            try req.content.encode(AuthenticationRequest(
                email: account.email,
                password: account.password
            ))
        }, afterResponse: { response async throws in
            authenticationResponse = try response.content.decode(AuthenticationResponse.self)
        })
        
        let headers = HTTPHeaders([("Authorization", "Bearer \(authenticationResponse.token)")])
        try await app.test(.DELETE, "accounts/\(createdAccount.account.id)", headers: headers, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .noContent)
        })
    }
    
    private func makeAccount(id: UUID = UUID(), name: String = "John", email: String = "jhondoe@mail.com", password: String = "@Strong4Password") -> Account {
        Account(id: id, name: name, email: email, password: password)
    }
    
    private func makeCreateAccountRequestModel(_ account: Account) -> CreateAccountRequest {
        CreateAccountRequest(name: account.name, email: account.email, password: account.password)
    }
}

struct AbortErrorResponse: Content {
    let reason: String
    let error: Bool
}
