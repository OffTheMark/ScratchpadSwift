import Foundation
import Firebase

enum SignUpFieldIdentifier: FieldIdentifier {
	case email
	case password
	case confirmPassword
}

class SignUpPresenter {
	// MARK:- Properties
	
	private weak var view: SignUpView?
	private let authentication: Auth
	
	// MARK:- SignUpPresenter
	
	init(view: SignUpView, authentication: Auth = Auth.auth()) {
		self.view = view
		self.authentication = authentication
	}
	
	func prepareView() {
		self.view?.display(model: SignUpViewModel())
	}
	
	func signUp(model: SignUpViewModel) {
		if let validationError = self.validate(model: model) {
			self.view?.display(error: validationError)
			return
		}
		
		self.authentication.createUser(withEmail: model.email, password: model.password) {
			(user, error) in
			if let error = error as NSError?, let signupError = self.convert(error: error) {
				self.view?.display(error: signupError)
			}
			else if let user = user {
				self.signOutUser()
				user.sendEmailVerification(completion: nil)
				self.view?.endSignUp()
			}
		}
	}
	
	private func signOutUser() {
		do {
			try self.authentication.signOut()
		}
		catch {}
	}
	
	private func validate(model: SignUpViewModel) -> SignUpError? {
		var error: SignUpError? = nil
		
		if !model.email.isEmail {
			error = SignUpError(field: SignUpFieldIdentifier.email, description: "Email is required.")
		}
		else if model.password != model.confirmPassword {
			error = SignUpError(field: SignUpFieldIdentifier.password, description: "Passwords don't match.")
		}
		
		return error
	}
	
	private func convert(error: NSError) -> SignUpError? {
		var signUpError: SignUpError? = nil
		
		guard let errorCode = AuthErrorCode(rawValue: error.code) else {
			return signUpError
		}
		
		if errorCode == .emailAlreadyInUse {
			signUpError = SignUpError(field: SignUpFieldIdentifier.email, description: "Email already in use.")
		}
		
		return signUpError
	}
}
