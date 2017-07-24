import Foundation
import UIKit

class CreationViewController: UIViewController {
	// MARK:- Outlets

	@IBOutlet fileprivate weak var saveButton: UIBarButtonItem!
	@IBOutlet fileprivate var contentView: UIView!
	@IBOutlet fileprivate weak var fieldsStackView: UIStackView!

	// MARK:- Properties

	private var presenter:          CreationPresenter?
	fileprivate var model:          CreationViewModel?
	fileprivate var titleTextFieldView: TextFieldView?
	fileprivate var textTextFieldView:  TextFieldView?

	// MARK:- UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		defer {
			self.presenter?.prepareView()
		}

		self.title = "Create Note"
		self.automaticallyAdjustsScrollViewInsets = false

		self.contentView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1)

		self.fieldsStackView.removeAllArrangedSubviews()

		self.titleTextFieldView = TextFieldView.make(identifier: CreationFieldIdentifier.title.rawValue, titleText: "Title", delegate: self)
		self.fieldsStackView.addArrangedSubview(self.titleTextFieldView!)

		self.textTextFieldView = TextFieldView.make(identifier: CreationFieldIdentifier.text.rawValue, titleText: "Text", delegate: self)
		self.fieldsStackView.addArrangedSubview(self.textTextFieldView!)

		self.saveButton.isEnabled = false

		self.presenter = CreationPresenter(view: self)
	}

	// MARK:- CreationTableViewController

	@IBAction func saveNote(_ sender: Any) {
		if let model = self.model {
			self.saveButton.isEnabled = false
			self.presenter?.createNote(model: model)
		}
	}
}

extension CreationViewController: TextFieldViewDelegate {
	func textDidChange(identifier: FieldIdentifier, text: String) {
		if identifier == CreationFieldIdentifier.title.rawValue {
			self.model?.title = text
			self.titleTextFieldView?.errors = nil
		}
		else if identifier == CreationFieldIdentifier.text.rawValue {
			self.model?.text = text
			self.textTextFieldView?.errors = nil
		}

		self.saveButton.isEnabled = true
	}
}

extension CreationViewController: CreationView {
	// MARK:- CreationView

	func display(model: CreationViewModel) {
		self.model = model
	}

	func display(errors: [ValidationError]) {
		if !errors.isEmpty {
			let titleErrors = errors.filter {
				$0.field == CreationFieldIdentifier.title.rawValue
			}
			let textErrors = errors.filter {
				$0.field == CreationFieldIdentifier.text.rawValue
			}

			self.titleTextFieldView?.errors = titleErrors
			self.textTextFieldView?.errors = textErrors

			if !titleErrors.isEmpty {
				self.titleTextFieldView?.textView.becomeFirstResponder()
			}
			else if !textErrors.isEmpty {
				self.textTextFieldView?.textView.becomeFirstResponder()
			}
		}
		else {
			self.titleTextFieldView?.errors = nil
			self.textTextFieldView?.errors = nil
		}

		self.saveButton.isEnabled = false
	}

	func endCreation() {
		self.navigationController?.popViewController(animated: true)
	}
}
