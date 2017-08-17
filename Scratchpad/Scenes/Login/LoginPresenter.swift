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
			if let user = user {
				
			}
			else if let error = error {
				
			}
		}
	}
	
	private func validate(model: LoginViewModel) -> [ValidationError] {
		var errors = [ValidationError]()
		
		if model.email.isEmpty {
			errors.append(ValidationError(field: LoginFieldIdentifier.email.rawValue, description: "Email is required."))
		}
		else if !model.email.isEmail {
			errors.append(ValidationError(field: LoginFieldIdentifier.email.rawValue, description: "Email must have a valid format."))
		}
		if model.password.isEmpty {
			errors.append(ValidationError(field: LoginFieldIdentifier.password.rawValue, description: "Password is required."))
		}
		
		return errors
	}
}
