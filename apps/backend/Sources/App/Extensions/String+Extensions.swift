import Foundation

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
        let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,63}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
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
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: self)
    }
}
