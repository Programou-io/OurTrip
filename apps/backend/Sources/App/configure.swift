import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import JWT

public func configure(_ app: Application) async throws {

     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    await app.jwt.keys.add(
        hmac: .init(stringLiteral: Environment.get("JWT_KEY") ?? "jwt_security_key"),
        digestAlgorithm: .sha256
    )
    
    app.passwords.use(.bcrypt)

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateAccountMigration())

    app.views.use(.leaf)

    try routes(app)
}
