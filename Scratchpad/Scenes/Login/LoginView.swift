import Foundation

protocol LoginView: class {
	func display(model: LoginViewModel)
	
	func display(errors: [ValidationError])
}

struct LoginViewModel {
	var email: String
	var password: String
	
	init(email: String = "", password: String = "") {
		self.email = email
		self.password = password
	}
}
