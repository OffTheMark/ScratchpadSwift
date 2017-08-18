import Foundation
import UIKit
import SwiftMessages

class SignupViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var subtitleLabel: UILabel!
	@IBOutlet private weak var shadowView: UIView!
	@IBOutlet private weak var fieldsView: UIView!
	@IBOutlet fileprivate weak var emailTextField: UITextField!
	@IBOutlet fileprivate weak var passwordTextField: UITextField!
	@IBOutlet fileprivate weak var confirmPasswordTextField: UITextField!
	@IBOutlet private weak var separatorView: UIView!
	@IBOutlet fileprivate weak var submitButton: UIButton!
	@IBOutlet private weak var cancelButton: UIButton!
	
	// MARK:- Properties
	
	private var presenter: SignupPresenter?
	fileprivate var model: SignupViewModel?
	fileprivate var canTrySignup: Bool {
		guard let model = self.model else {
			return false
		}
		return !model.email.isEmpty && !model.password.isEmpty && !model.confirmPassword.isEmpty
	}
	
	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defer {
			self.presenter = SignupPresenter(view: self)
			self.presenter?.prepareView()
		}
		
		self.titleLabel.text = "Scratchpad"
		
		self.subtitleLabel.text = "Fill in the fields to create your account."
		
		self.view.backgroundColor = ColorTheme.lightBackground
		
		self.shadowView.layer.cornerRadius = 6.0
		self.shadowView.layer.shadowRadius = 4.0
		self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
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
		
		self.confirmPasswordTextField.placeholder = "Confirm password"
		self.confirmPasswordTextField.isSecureTextEntry = true
		self.confirmPasswordTextField.autocorrectionType = .no
		self.confirmPasswordTextField.spellCheckingType = .no
		
		self.submitButton.setTitle("Submit", for: .normal)
		self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
		self.submitButton.isEnabled = false
		
		self.cancelButton.setTitle("Cancel", for: .normal)
		
		self.separatorView.backgroundColor = ColorTheme.mediumBorder
	}
	
	// MARK:- SignupViewController
	
	func submit() {
		if let model = self.model {
			self.presenter?.signup(model: model)
		}
	}
	
	@IBAction func emailTextFieldChanged(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.email = text
		}
		self.submitButton.isEnabled = self.canTrySignup
	}
	
	@IBAction func passwordTextFieldChanged(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.password = text
		}
		self.submitButton.isEnabled = self.canTrySignup
	}
	
	@IBAction func confirmPasswordTextFieldChanged(_ sender: UITextField) {
		if let text = sender.text {
			self.model?.confirmPassword = text
		}
		self.submitButton.isEnabled = self.canTrySignup
	}
}

extension SignupViewController: SignupView {
	// MARK:- SignupView
	
	func display(model: SignupViewModel) {
		self.model = model
	}
	
	func display(error: SignupError) {
		if let field = error.field {
			if field == .email {
				self.emailTextField.becomeFirstResponder()
			}
			else if field == .password {
				self.passwordTextField.becomeFirstResponder()
			}
		}
		
		self.showErrorMessage(for: error)
		
		self.submitButton.isEnabled = self.canTrySignup
	}
	
	func endSignup() {
		self.showSuccessMessage()
		self.performSegue(withIdentifier: "SignupToLogin", sender: nil)
	}
	
	private func showErrorMessage(for error: SignupError) {
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
	
	private func showSuccessMessage() {
		let view = MessageView.viewFromNib(layout: .MessageView)
		var config = SwiftMessages.Config()
		
		config.presentationStyle = .bottom
		config.ignoreDuplicates = false
		
		view.configureTheme(.success)
		view.configureDropShadow()
		view.configureContent(
			title: "Account created",
			body: "Please confirm your email before signing in to your account.",
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
