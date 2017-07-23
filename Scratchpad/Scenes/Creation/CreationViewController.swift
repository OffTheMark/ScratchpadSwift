import Foundation
import UIKit

class CreationViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet fileprivate weak var saveButton: UIBarButtonItem!
	@IBOutlet fileprivate var contentView: UIView!
	@IBOutlet fileprivate weak var titleLabel: UILabel!
	@IBOutlet fileprivate weak var textLabel: UILabel!
	@IBOutlet private weak var titleFieldView: UIView!
	@IBOutlet private weak var textFieldView: UIView!
	@IBOutlet fileprivate weak var titleTextView: UITextView!
	@IBOutlet fileprivate weak var textTextView: UITextView!
	
	// MARK:- Properties
	
	fileprivate var presenter: CreationPresenter?
	fileprivate var viewModel: CreationViewModel?
	fileprivate var validationErrors: [ValidationError]?
	
	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defer { self.presenter?.prepareView() }
		
		self.title = "Create Note"
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.contentView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1)
		
		self.titleLabel.text = "Title".uppercased()
		self.titleLabel.textColor = UIColor.darkGray
		
		self.textLabel.text = "Text".uppercased()
		self.textLabel.textColor = UIColor.darkGray
		
		self.titleTextView.delegate = self
		self.titleTextView.isScrollEnabled = false
		self.titleTextView.tag = CreationFieldIdentifier.title.rawValue
	
		self.textTextView.delegate = self
		self.textTextView.isScrollEnabled = false
		self.textTextView.tag = CreationFieldIdentifier.text.rawValue
		
		self.saveButton.isEnabled = false
		
		self.presenter = CreationPresenter(view: self)
	}
	
	// MARK:- CreationTableViewController
	
	@IBAction func saveNote(_ sender: Any) {
		if let model = self.viewModel {
			self.saveButton.isEnabled = false
			self.presenter?.createNote(model: model)
		}
	}
	
	func dismissKeyboard() {
		self.view.endEditing(true)
	}
}

extension CreationViewController: UITextViewDelegate {
	// MARK:- UITextViewDelegate
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		let textFieldToolbar = UIToolbar()
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
		
		textFieldToolbar.items = [flexibleSpace, doneButton]
		textFieldToolbar.sizeToFit()
		
		textView.inputAccessoryView = textFieldToolbar
		
		return true
	}
	
	func textViewDidChange(_ textView: UITextView) {
		if textView.tag == CreationFieldIdentifier.title.rawValue {
			self.viewModel?.title = textView.text
		}
		else if textView.tag == CreationFieldIdentifier.text.rawValue {
			self.viewModel?.text = textView.text
		}
		
		self.saveButton.isEnabled = true
	}
}

extension CreationViewController: CreationView {
	// MARK:- CreationView
	
	func display(model: CreationViewModel) {
		self.viewModel = model
	}
	
	func display(errors: [ValidationError]) {
		self.validationErrors = errors
		self.saveButton.isEnabled = false
	}
	
	func endCreation() {
		self.navigationController?.popViewController(animated: true)
	}
}
