import Fluent

struct CreateAccountMigration: AsyncMigration {
    private let schema = AccountModel.schema
    func prepare(on database: Database) async throws {
        try await database.schema(schema)
            .id()
            .field(AccountModel.FieldName.name, .string, .required)
            .field(AccountModel.FieldName.email, .string, .required)
            .field(AccountModel.FieldName.password, .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
