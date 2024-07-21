import Vapor
import Fluent

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("authentication", use: authenticateAccount)
    }
    
    @Sendable private func authenticateAccount(request: Request) async throws -> Response {
        let authenticationRequest = try request.content.decode(AuthenticationRequest.self)
        
        guard let account = try await AccountModel.query(on: request.db)
            .filter(\.$email == authenticationRequest.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        let isPasswordCorrect = try Bcrypt.verify(
            authenticationRequest.password,
            created: account.password
        )
        guard isPasswordCorrect else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        let assignedToken = try await request.jwt.sign(
            SessionToken(accountId: try account.requireID()),
            kid: "auth"
        )
        let authenticatinoResponse = AuthenticationResponse(token: assignedToken)
        
        return try await authenticatinoResponse.encodeResponse(status: .ok, for: request)
    }
}
