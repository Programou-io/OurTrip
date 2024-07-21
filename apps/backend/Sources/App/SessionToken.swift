import Vapor
import JWT

struct SessionToken: Content, Authenticatable, JWTPayload {

    var expiration: ExpirationClaim
    var accountId: UUID

    init(accountId: UUID) {
        self.accountId = accountId
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(60 * 15))
    }

    func verify(using algorithm: some JWTAlgorithm) throws {
        try expiration.verifyNotExpired()
    }
}
