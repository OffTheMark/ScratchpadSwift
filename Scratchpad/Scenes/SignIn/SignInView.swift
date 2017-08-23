import Foundation

protocol SignInView: class {
	func display(model: SignInViewModel)
	
	func display(error: SignInError)
	
	func endSignIn()
}

struct SignInViewModel {
	var email: String
	var password: String
	
	init(email: String = "", password: String = "") {
		self.email = email
		self.password = password
	}
}

struct SignInError {
	let field:       SignInFieldIdentifier?
	let description: String
	
	init(field: SignInFieldIdentifier? = nil, description: String) {
		self.field = field
		self.description = description
	}
}
