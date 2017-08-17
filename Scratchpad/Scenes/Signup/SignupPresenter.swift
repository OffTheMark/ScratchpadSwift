import Foundation

enum SignupFieldIdentifier: FieldIdentifier {
	case email
	case password
	case confirmPassword
}

class SignupPresenter {
	// MARK:- Properties
	
	private weak var view: SignupView?
	
	// MARK:- SignupPresenter
	
	init(view: SignupView) {
		self.view = view
	}
	
	func prepareView() {
		self.view?.display(model: SignupViewModel())
	}
	
	private func validate(model: SignupViewModel) -> [ValidationError] {
		var errors = [ValidationError]()
		
		if model.email.isEmpty {
			errors.append(ValidationError(field: SignupFieldIdentifier.email.rawValue, description: "Email is required."))
		}
		if model.password.isEmpty {
			errors.append(ValidationError(field: SignupFieldIdentifier.password.rawValue, description: "Password is required."))
		}
		
		return errors
	}
}
