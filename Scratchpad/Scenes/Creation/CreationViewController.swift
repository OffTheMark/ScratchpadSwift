import Foundation
import UIKit

class CreationViewController: UIViewController {
	// MARK:- Outlets

	@IBOutlet fileprivate weak var saveButton: UIBarButtonItem!
	@IBOutlet fileprivate var contentView: UIView!
	@IBOutlet fileprivate weak var fieldsStackView: UIStackView!

	// MARK:- Properties

	private var     presenter:          CreationPresenter?
	fileprivate var model:              CreationViewModel?
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

		self.navigationItem.setHidesBackButton(true, animated: false)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCreation))

		self.contentView.backgroundColor = ColorTheme.lightBackground

		self.fieldsStackView.removeAllArrangedSubviews()

		self.titleTextFieldView = TextFieldView.make(identifier: CreationFieldIdentifier.title.rawValue, title: "Title", delegate: self)
		self.fieldsStackView.addArrangedSubview(self.titleTextFieldView!)

		self.textTextFieldView = TextFieldView.make(identifier: CreationFieldIdentifier.text.rawValue, title: "Text", delegate: self)
		self.fieldsStackView.addArrangedSubview(self.textTextFieldView!)

		self.saveButton.title = "Save"

		self.presenter = CreationPresenter(view: self)
	}

	// MARK:- CreationTableViewController

	@IBAction func saveNote(_ sender: Any) {
		if let model = self.model {
			self.saveButton.isEnabled = false
			self.presenter?.createNote(model: model)
		}
	}

	func cancelCreation() {
		if let model = model,
		   self.presenter?.canSafelyCancel(model: model) ?? false {
			self.presenter?.cancelCreation()
		}
		else {
			let alertController = UIAlertController(title: "Cancel", message: "Are you sure you wish to leave without saving?", preferredStyle: .alert)
			let cancelAction    = UIAlertAction(title: "No", style: .default, handler: nil)
			let confirmAction = UIAlertAction(title: "Yes", style: .default) {
				result -> Void in
				self.presenter?.cancelCreation()
			}
			alertController.addAction(cancelAction)
			alertController.addAction(confirmAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}
}

extension CreationViewController: TextFieldViewDelegate {
	// MARK:- TextFieldViewDelegate

	func textDidChange(identifier: FieldIdentifier, text: String) {
		if identifier == CreationFieldIdentifier.title.rawValue {
			self.model?.title = text
			self.titleTextFieldView?.errors = []
		}
		else if identifier == CreationFieldIdentifier.text.rawValue {
			self.model?.text = text
			self.textTextFieldView?.errors = []
		}
	}
}

extension CreationViewController: CreationView {
	// MARK:- CreationView

	func display(model: CreationViewModel) {
		self.model = model
		self.titleTextFieldView?.text = model.title
		self.textTextFieldView?.text = model.text
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
				self.titleTextFieldView?.giveFocus()
			}
			else if !textErrors.isEmpty {
				self.textTextFieldView?.giveFocus()
			}
		}
		else {
			self.titleTextFieldView?.errors = []
			self.textTextFieldView?.errors = []
		}
		
		self.saveButton.isEnabled = true
	}

	func endCreation() {
		self.navigationController?.popViewController(animated: true)
	}
}
