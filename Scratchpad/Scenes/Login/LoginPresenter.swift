import Foundation
import FirebaseAuth

enum LoginFieldIdentifier: FieldIdentifier {
	case email
	case password
}


class LoginPresenter {
	// MARK:- Properties
	
	private weak var view: LoginView?
	
	// MARK:- LoginPresenter
	
	init(view: LoginView) {
		self.view = view
	}
	
	func prepareView() {
		self.view?.display(model: LoginViewModel())
	}
	
	func login(model: LoginViewModel) {
		let errors = self.validate(model: model)
		
		guard errors.isEmpty else {
			self.view?.display(errors: errors)
			return
		}
		
		Auth.auth().signIn(withEmail: model.email, password: model.password) {
			(user, error) in
			if let error = error as NSError? {
				self.view?.display(errors: self.validate(error: error))
			}
			else if let user = user /*, user.isEmailVerified */ /* TODO: Uncomment once sign up and email verification are implemented  */ {
				self.view?.endLogin()
			}
			else {
				let error = LoginError(field: LoginFieldIdentifier.email, description: "Email has not been verified.")
				self.view?.display(errors: [error])
			}
		}
	}
	
	private func validate(error: NSError) -> [LoginError] {
		var errors = [LoginError]()
		
		guard let errorCode = AuthErrorCode(rawValue: error.code) else {
			return errors
		}
		
		if errorCode == .userNotFound {
			errors.append(LoginError(field: LoginFieldIdentifier.email, description: "User not found."))
		}
		else if errorCode == .wrongPassword {
			errors.append(LoginError(field: LoginFieldIdentifier.password, description: "Incorrect password."))
		}
		
		return errors
	}
	
	private func validate(model: LoginViewModel) -> [LoginError] {
		var errors = [LoginError]()
		
		if !model.email.isEmail {
			errors.append(LoginError(field: LoginFieldIdentifier.email, description: "Email must have a valid format."))
		}
		
		return errors
	}
}
