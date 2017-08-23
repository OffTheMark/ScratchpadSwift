import Foundation
import FirebaseAuth

enum SignInFieldIdentifier: FieldIdentifier {
	case email
	case password
}

class SignInPresenter {
	// MARK:- Properties
	
	private weak var view: SignInView?
	private let authentication: Auth
	
	// MARK:- SignInPresenter
	
	init(view: SignInView, authentication: Auth = Auth.auth()) {
		self.view = view
		self.authentication = authentication
	}
	
	func prepareView() {
		self.view?.display(model: SignInViewModel())
	}
	
	func signIn(model: SignInViewModel) {
		if let validationError = self.validate(model: model) {
			self.view?.display(error: validationError)
			return
		}
		
		self.authentication.signIn(withEmail: model.email, password: model.password) {
			(user, error) in
			if let error = error as NSError?, let loginError = self.convert(error: error) {
				self.view?.display(error: loginError)
			}
			else if let user = user, user.isEmailVerified {
				self.view?.endSignIn()
			}
			else {
				let emailNotVerifiedError = SignInError(field: SignInFieldIdentifier.email, description: "Email has not been verified.")
				self.view?.display(error: emailNotVerifiedError)
			}
		}
	}
	
	private func convert(error: NSError) -> SignInError? {
		var signInError: SignInError? = nil
		
		guard let errorCode = AuthErrorCode(rawValue: error.code) else {
			return signInError
		}
		
		if errorCode == .userNotFound {
			signInError = SignInError(field: SignInFieldIdentifier.email, description: "User not found.")
		}
		else if errorCode == .wrongPassword {
			signInError = SignInError(field: SignInFieldIdentifier.password, description: "Incorrect password.")
		}
		else if errorCode == .userDisabled {
			signInError = SignInError(field: SignInFieldIdentifier.email, description: "User has been disabled.")
		}
		
		return signInError
	}
	
	private func validate(model: SignInViewModel) -> SignInError? {
		var error: SignInError? = nil
		
		if !model.email.isEmail {
			error = SignInError(field: SignInFieldIdentifier.email, description: "Email must have a valid format.")
		}
		
		return error
	}
}
