import Foundation

protocol AccountRepository {
    func save(_ account: Account) async throws
    func findAll() async throws -> [Account]
    func findBy(id: UUID) async throws -> Account?
    func findBy(email: String) async throws -> Account?
    func delete(_ account: Account) async throws
    func update(_ account: Account) async throws
}
