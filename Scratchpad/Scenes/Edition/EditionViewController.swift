import Foundation
import UIKit

class EditionViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet fileprivate weak var saveButton: UIBarButtonItem!
	@IBOutlet private weak var fieldsStackView: UIStackView!
	@IBOutlet private var contentView: UIView!
	
	
	// MARK:- Properties
	
	var noteIdentifier: NoteIdentifier?
	private var presenter: EditionPresenter?
	fileprivate var model: EditionViewModel?
	fileprivate var titleTextFieldView: TextFieldView?
	fileprivate var textTextFieldView:  TextFieldView?
	
	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Edit Note"
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.contentView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1)
		
		self.fieldsStackView.removeAllArrangedSubviews()
		
		self.titleTextFieldView = TextFieldView.make(identifier: EditionFieldIdentifier.title.rawValue, title: "Title", delegate: self)
		self.fieldsStackView.addArrangedSubview(self.titleTextFieldView!)
		
		self.textTextFieldView = TextFieldView.make(identifier: EditionFieldIdentifier.text.rawValue, title: "Text", delegate: self)
		self.fieldsStackView.addArrangedSubview(self.textTextFieldView!)
		
		self.saveButton.title = "Save"
		self.saveButton.isEnabled = false
		
		self.presenter = EditionPresenter(view: self, identifier: self.noteIdentifier!)
	}
	
	// MARK:- EditionViewController
	
	@IBAction func saveNote(_ sender: Any) {
		if let model = self.model {
			self.saveButton.isEnabled = false
			self.presenter?.saveNote(model: model)
		}
	}
}

extension EditionViewController: TextFieldViewDelegate {
	// MARK:- TextFieldViewDelegate
	
	func textDidChange(identifier: FieldIdentifier, text: String) {
		if identifier == EditionFieldIdentifier.title.rawValue {
			self.model?.title = text
			self.titleTextFieldView?.errors = nil
		}
		else if identifier == EditionFieldIdentifier.text.rawValue {
			self.model?.text = text
			self.textTextFieldView?.errors = nil
		}
		
		self.saveButton.isEnabled = true
	}
}

extension EditionViewController: EditionView {
	// MARK:- EditionView
	
	func display(model: EditionViewModel) {
		self.model = model
		
		self.titleTextFieldView?.text = model.title
		self.textTextFieldView?.text = model.text
	}
	
	func display(errors: [ValidationError]) {
		if !errors.isEmpty {
			let titleErrors = errors.filter {
				$0.field == EditionFieldIdentifier.title.rawValue
			}
			let textErrors = errors.filter {
				$0.field == EditionFieldIdentifier.text.rawValue
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
			self.titleTextFieldView?.errors = nil
			self.textTextFieldView?.errors = nil
		}
		
		self.saveButton.isEnabled = false
	}
	
	func endEdition() {
		self.navigationController?.popViewController(animated: true)
	}
}
