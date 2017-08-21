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
		if let validationError = self.validate(model: model) {
			self.view?.display(error: validationError)
			return
		}
		
		Auth.auth().signIn(withEmail: model.email, password: model.password) {
			(user, error) in
			if let error = error as NSError?, let loginError = self.convert(error: error) {
				self.view?.display(error: loginError)
			}
			else if let user = user, user.isEmailVerified {
				self.view?.endLogin()
			}
			else {
				let emailNotVerifiedError = LoginError(field: LoginFieldIdentifier.email, description: "Email has not been verified.")
				self.view?.display(error: emailNotVerifiedError)
			}
		}
	}
	
	private func convert(error: NSError) -> LoginError? {
		var loginError: LoginError? = nil
		
		guard let errorCode = AuthErrorCode(rawValue: error.code) else {
			return loginError
		}
		
		if errorCode == .userNotFound {
			loginError = LoginError(field: LoginFieldIdentifier.email, description: "User not found.")
		}
		else if errorCode == .wrongPassword {
			loginError = LoginError(field: LoginFieldIdentifier.password, description: "Incorrect password.")
		}
		else if errorCode == .userDisabled {
		loginError = LoginError(field: LoginFieldIdentifier.email, description: "User has been disabled.")
		}
		
		return loginError
	}
	
	private func validate(model: LoginViewModel) -> LoginError? {
		var error: LoginError? = nil
		
		if !model.email.isEmail {
			error = LoginError(field: LoginFieldIdentifier.email, description: "Email must have a valid format.")
		}
		
		return error
	}
}
