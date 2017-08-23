import Foundation
import Firebase

enum SignupFieldIdentifier: FieldIdentifier {
	case email
	case password
	case confirmPassword
}

class SignupPresenter {
	// MARK:- Properties
	
	private weak var view: SignupView?
	private let authentication: Auth
	
	// MARK:- SignupPresenter
	
	init(view: SignupView, authentication: Auth = Auth.auth()) {
		self.view = view
		self.authentication = authentication
	}
	
	func prepareView() {
		self.view?.display(model: SignupViewModel())
	}
	
	func signup(model: SignupViewModel) {
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
				self.view?.endSignup()
			}
		}
	}
	
	private func signOutUser() {
		do {
			try self.authentication.signOut()
		}
		catch {}
	}
	
	private func validate(model: SignupViewModel) -> SignupError? {
		var error: SignupError? = nil
		
		if !model.email.isEmail {
			error = SignupError(field: SignupFieldIdentifier.email, description: "Email is required.")
		}
		else if model.password != model.confirmPassword {
			error = SignupError(field: SignupFieldIdentifier.password, description: "Passwords don't match.")
		}
		
		return error
	}
	
	private func convert(error: NSError) -> SignupError? {
		var signupError: SignupError? = nil
		
		guard let errorCode = AuthErrorCode(rawValue: error.code) else {
			return signupError
		}
		
		if errorCode == .emailAlreadyInUse {
			signupError = SignupError(field: SignupFieldIdentifier.email, description: "Email already in use.")
		}
		
		return signupError
	}
}
