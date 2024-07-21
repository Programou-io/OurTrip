import Foundation

final class InMemoryAccountRepositoryAdapter: AccountRepository {
    private var accounts = [Account]()
    
    func save(_ account: Account) async throws {
        accounts.append(account)
    }
    
    func findAll() async throws -> [Account] {
        accounts
    }
    
    func findBy(id: UUID) async throws -> Account? {
        accounts.filter { $0.id == id }.first
    }
    
    func findBy(email: String) async throws -> Account? {
        accounts.filter { $0.email == email }.first
    }
    
    func delete(_ account: Account) async throws {
        accounts.removeAll { $0.id == account.id }
    }
    
    func update(_ account: Account) async throws {
        let accountIndex = accounts.firstIndex { $0.id == account.id }!
        accounts[accountIndex] = account
    }
}
