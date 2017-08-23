import Foundation

protocol SignUpView: class {
	func display(model: SignUpViewModel)
	
	func display(error: SignUpError)
	
	func endSignUp()
}

struct SignUpViewModel {
	var email: String
	var password: String
	var confirmPassword: String
	
	init(email: String = "", password: String = "", confirmPassword: String = "") {
		self.email = email
		self.password = password
		self.confirmPassword = confirmPassword
	}
}

struct SignUpError {
	let field:       SignUpFieldIdentifier?
	let description: String
	
	init(field: SignUpFieldIdentifier? = nil, description: String) {
		self.field = field
		self.description = description
	}
}
