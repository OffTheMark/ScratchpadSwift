import Foundation

protocol LoginView: class {
	func display(model: LoginViewModel)
	
	func display(errors: [LoginError])
	
	func endLogin()
}

struct LoginViewModel {
	var email: String
	var password: String
	
	init(email: String = "", password: String = "") {
		self.email = email
		self.password = password
	}
}

struct LoginError {
	let field: LoginFieldIdentifier?
	let description: String
	
	init(field: LoginFieldIdentifier? = nil, description: String) {
		self.field = field
		self.description = description
	}
}
