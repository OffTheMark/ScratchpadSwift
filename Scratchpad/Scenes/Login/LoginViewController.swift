import Foundation
import UIKit
import SwiftMessages

class LoginViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var subtitleLabel: UILabel!
	@IBOutlet private weak var shadowView: UIView!
	@IBOutlet private weak var fieldsView: UIView!
	@IBOutlet fileprivate weak var emailTextField: UITextField!
	@IBOutlet fileprivate weak var passwordTextField: UITextField!
	@IBOutlet private weak var separatorView: UIView!
	@IBOutlet fileprivate weak var loginButton: UIButton!
	@IBOutlet private weak var signupButton: UIButton!
	
	// MARK:- Properties
	
	private var presenter: LoginPresenter?
	fileprivate var model: LoginViewModel?
	fileprivate var canTryLogin: Bool {
		guard let model = self.model else {
			return false
		}
		return !model.email.isEmpty && !model.password.isEmpty
	}

	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defer {
			self.presenter = LoginPresenter(view: self)
			self.presenter?.prepareView()
		}
		
		self.titleLabel.text = "Scratchpad"
		
		self.subtitleLabel.text = "Write stuff down"
		
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
		
		self.loginButton.setTitle("Login", for: .normal)
		self.loginButton.isEnabled = false
		
		self.signupButton.setTitle("Sign up", for: .normal)
		
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
		self.loginButton.isEnabled = self.canTryLogin
	}
	
	@IBAction func passwordTextFieldDidChange(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.password = text
		}
		self.loginButton.isEnabled = self.canTryLogin
	}
	
	class func make() -> LoginViewController {
		let storyboard = UIStoryboard(name: "Login", bundle: nil)
		let controller = storyboard.instantiateInitialViewController() as! LoginViewController
		return controller
	}
	
	fileprivate func makeLabel(for error: LoginError) -> UILabel {
		let label = UILabel()
		label.text = error.description
		label.textColor = ColorTheme.errorText
		label.font = UIFont.systemFont(ofSize: 13)
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}
	
	fileprivate func showAlert(for error: LoginError) {
		let view = MessageView.viewFromNib(layout: .MessageView)
		var config = SwiftMessages.defaultConfig
		
		config.presentationStyle = .bottom
		config.ignoreDuplicates = true
		
		view.configureTheme(.error)
		view.configureDropShadow()
		view.configureContent(
			title: error.description,
			body: nil,
			iconImage: nil,
			iconText: nil,
			buttonImage: nil,
			buttonTitle: nil,
			buttonTapHandler: nil)
		view.button?.isHidden = true
		
		SwiftMessages.hideAll()
		SwiftMessages.show(config: config, view: view)
	}
}

extension LoginViewController: LoginView {
	// MARK:- LoginView
	
	func display(model: LoginViewModel) {
		self.model = model
		self.loginButton.isEnabled = self.canTryLogin
	}
	
	func display(errors: [LoginError]) {
		if let firstError = errors.first {
			if let field = firstError.field {
				if field == .email {
					self.emailTextField.becomeFirstResponder()
				}
				else if field == .password {
					self.passwordTextField.becomeFirstResponder()
				
				}
			}
			
			self.showAlert(for: firstError)
		}
		
		self.loginButton.isEnabled = self.canTryLogin
	}
	
	func endLogin() {
		self.performSegue(withIdentifier: "ShowListing", sender: nil)
	}
}
