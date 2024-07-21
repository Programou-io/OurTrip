import Foundation
import Vapor
import Fluent

final class AccountModel: Model, @unchecked Sendable {
    
    static let schema = "accounts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldName.name)
    var name: String
    
    @Field(key: FieldName.email)
    var email: String
    
    @Field(key: FieldName.password)
    var password: String
    
    required init() {}
    
    init(id: UUID? = nil, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
    
    enum FieldName {
        static let name = FieldKey("name")
        static let email = FieldKey("email")
        static let password = FieldKey("password")
    }
}
