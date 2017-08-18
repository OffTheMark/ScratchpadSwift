import Foundation

protocol SignupView: class {
	func display(model: SignupViewModel)
	
	func display(error: SignupError)
	
	func endSignup()
}

struct SignupViewModel {
	var email: String
	var password: String
	var confirmPassword: String
	
	init(email: String = "", password: String = "", confirmPassword: String = "") {
		self.email = email
		self.password = password
		self.confirmPassword = confirmPassword
	}
}

struct SignupError {
	let field: SignupFieldIdentifier?
	let description: String
	
	init(field: SignupFieldIdentifier? = nil, description: String) {
		self.field = field
		self.description = description
	}
}
