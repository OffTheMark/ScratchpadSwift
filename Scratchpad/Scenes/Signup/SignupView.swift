import Foundation

protocol SignupView: class {
	func display(model: SignupViewModel)
	
	func display(errors: [ValidationError])
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
