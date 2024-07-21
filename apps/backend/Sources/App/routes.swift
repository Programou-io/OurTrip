import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { _ in "Wellcome to Our Trip" }

    try app.register(collection: AuthenticationController())
    try app.register(collection: AccountController())
}

extension String {
    /**
     Exemplos:
     
     - "a" - False
     - "Aud" - False
     - "Audar" - True
     */
    var isValidName: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).count >= 4
    }
    
    /**
     Exemplos:
     
     - "exemplo@dominio.com" - True
     - "emailinvalido@" - False
     */
    var isValidEmail: Bool {
        true
    }
    
    /**
     Critérios da senha:
     
     - Pelo menos 8 caracteres
     - Pelo menos 1 letra maiúscula
     - Pelo menos 1 letra minúscula
     - Pelo menos 1 dígito
     - Pelo menos 1 caractere especial
     
     Exemplos:
     
     - "SenhaForte@123 - True
     - "senha123" - False (sem letra maiúscula e caractere especial)
     - "Senha123" - False (sem caractere especial)
     - "SenhaForte" - False (sem dígito e caractere especial)
     */
    var isValidPassword: Bool {
        true
    }
}
