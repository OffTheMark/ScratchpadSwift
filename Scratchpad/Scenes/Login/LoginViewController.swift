import Foundation
import UIKit

class LoginViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var shadowView: UIView!
	@IBOutlet private weak var fieldsView: UIView!
	@IBOutlet private weak var emailTextField: UITextField!
	@IBOutlet private weak var passwordTextField: UITextField!
	@IBOutlet private weak var separatorView: UIView!
	@IBOutlet fileprivate weak var loginButton: UIButton!
	@IBOutlet private weak var signupButton: UIButton!
	
	// MARK:- Properties
	
	private var presenter: LoginPresenter?
	fileprivate var model: LoginViewModel?

	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defer {
			self.presenter = LoginPresenter(view: self)
			self.presenter?.prepareView()
		}
		
		self.titleLabel.text = "Scratchpad"
		
		self.shadowView.layer.cornerRadius = 6.0
		self.shadowView.layer.shadowRadius = 4.0
		self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
		self.shadowView.layer.shadowColor = UIColor.black.cgColor
		self.shadowView.layer.shadowOpacity = 0.25
		
		self.fieldsView.layer.cornerRadius = 8.0
		self.fieldsView.clipsToBounds = true
		self.fieldsView.backgroundColor = ColorTheme.whiteBackground
		
		self.emailTextField.placeholder = "Email"
		self.emailTextField.keyboardType = .emailAddress
		self.emailTextField.autocorrectionType = .no
		self.emailTextField.spellCheckingType = .no
		
		self.passwordTextField.placeholder = "Password"
		self.passwordTextField.isSecureTextEntry = true
		self.passwordTextField.autocorrectionType = .no
		self.passwordTextField.spellCheckingType = .no
		
		self.separatorView.backgroundColor = ColorTheme.mediumBorder
	}
	
	// MARK:- LoginViewController
	
	@IBAction func login(_ sender: Any) {
		if let model = self.model {
			self.loginButton.isEnabled = false
			self.presenter?.login(model: model)
		}
	}
	
	@IBAction func emailTextFieldDidChange(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.email = text
		}
	}
	
	@IBAction func passwordTextFieldDidChange(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.password = text
		}
	}
}

extension LoginViewController: LoginView {
	// MARK:- LoginView
	
	func display(model: LoginViewModel) {
		self.model = model
	}
	
	func display(errors: [ValidationError]) {
		let errors = errors
		self.loginButton.isEnabled = true
	}
}
