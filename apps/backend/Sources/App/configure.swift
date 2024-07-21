import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import JWT

public func configure(_ app: Application) async throws {
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    guard let jwtSecret = Environment.get("JWT_SECRET") else {
        throw MissingEnvironmentVaribleError("JWT_SECRET")
    }
    
    await app.jwt.keys.add(hmac: .init(stringLiteral: jwtSecret), digestAlgorithm: .sha256)
    
    app.passwords.use(.bcrypt)
    
    app.views.use(.leaf)
    
    try routes(app)
}
