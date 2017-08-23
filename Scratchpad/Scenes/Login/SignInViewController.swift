import Foundation
import UIKit
import SwiftMessages

class SignInViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet private weak var     titleLabel:        UILabel!
	@IBOutlet private weak var     subtitleLabel:     UILabel!
	@IBOutlet private weak var     shadowView:        UIView!
	@IBOutlet private weak var     fieldsView:        UIView!
	@IBOutlet fileprivate weak var emailTextField:    UITextField!
	@IBOutlet fileprivate weak var passwordTextField: UITextField!
	@IBOutlet private weak var     separatorView:     UIView!
	@IBOutlet fileprivate weak var signInButton:      UIButton!
	@IBOutlet private weak var     signUpButton:      UIButton!
	
	// MARK:- Properties
	
	private var     presenter:    SignInPresenter?
	fileprivate var model:        SignInViewModel?
	fileprivate var canTrySignIn: Bool {
		guard let model = self.model else {
			return false
		}
		return !model.email.isEmpty && !model.password.isEmpty
	}

	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defer {
			self.presenter = SignInPresenter(view: self)
			self.presenter?.prepareView()
		}
		
		self.titleLabel.text = "Scratchpad"
		
		self.subtitleLabel.text = "Write stuff down"
		
		self.view.backgroundColor = ColorTheme.lightBackground
		
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
		
		self.signInButton.setTitle("Sign in", for: .normal)
		self.signInButton.isEnabled = false
		self.signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
		
		self.signUpButton.setTitle("Sign up", for: .normal)
		self.signUpButton.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
		
		self.separatorView.backgroundColor = ColorTheme.mediumBorder
	}
	
	// MARK:- SignInViewController
	
	func signIn() {
		if let model = self.model {
			self.signInButton.isEnabled = false
			self.presenter?.signIn(model: model)
		}
	}
	
	func showSignUp() {
		self.performSegue(withIdentifier: "SignInToSignUp", sender: nil)
	}
	
	@IBAction func emailTextFieldChanged(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.email = text
		}
		self.signInButton.isEnabled = self.canTrySignIn
	}
	
	@IBAction func passwordTextFieldChanged(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.password = text
		}
		self.signInButton.isEnabled = self.canTrySignIn
	}
	
	class func make() -> SignInViewController {
		let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
		let controller = storyboard.instantiateInitialViewController() as! SignInViewController
		return controller
	}
	
	fileprivate func makeLabel(for error: SignInError) -> UILabel {
		let label = UILabel()
		label.text = error.description
		label.textColor = ColorTheme.errorText
		label.font = UIFont.systemFont(ofSize: 13)
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}
}

extension SignInViewController: SignInView {
	// MARK:- SignInView
	
	func display(model: SignInViewModel) {
		self.model = model
		self.signInButton.isEnabled = self.canTrySignIn
	}
	
	func display(error: SignInError) {
		if let field = error.field {
			if field == .email {
				self.emailTextField.becomeFirstResponder()
			}
			else if field == .password {
				self.passwordTextField.becomeFirstResponder()
			}
		}
			
		self.showErrorMessage(for: error)
		self.signInButton.isEnabled = self.canTrySignIn
	}
	
	func endSignIn() {
		self.performSegue(withIdentifier: "SignInToListing", sender: nil)
	}
	
	private func showErrorMessage(for error: SignInError) {
		let view = MessageView.viewFromNib(layout: .MessageView)
		var config = SwiftMessages.Config()
		
		config.presentationStyle = .bottom
		config.ignoreDuplicates = false
		
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
