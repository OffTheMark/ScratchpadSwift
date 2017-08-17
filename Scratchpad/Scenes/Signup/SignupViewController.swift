import Foundation
import UIKit

class SignupViewController: UIViewController {
	// MARK:- Outlets
	
	
	// MARK:- Properties
	
	private var presenter: SignupPresenter?
	fileprivate var model: SignupViewModel?
	
	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defer { self.presenter?.prepareView() }
		
		self.presenter = SignupPresenter(view: self)
	}
	
	// MARK:- SignupViewController
	
	
}

extension SignupViewController: SignupView {
	// MARK:- SignupView
	
	func display(model: SignupViewModel) {
		self.model = model
	}
	
	func display(errors: [ValidationError]) {
		
	}
}
