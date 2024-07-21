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
