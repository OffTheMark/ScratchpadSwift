import Foundation
import UIKit

class EditionViewController: UIViewController {
	// MARK:- Outlets

	@IBOutlet fileprivate weak var saveButton:      UIBarButtonItem!
	@IBOutlet private weak var     fieldsStackView: UIStackView!
	@IBOutlet private weak var titleLabelView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var titleTextView: UITextView!
	@IBOutlet private weak var textLabelView: UIView!
	@IBOutlet private weak var textLabel: UILabel!
	@IBOutlet private weak var textTextView: UITextView!

	// MARK:- Properties

	var noteIdentifier: NoteIdentifier?
	private var     presenter:          EditionPresenter?
	fileprivate var model:              EditionViewModel? {
		didSet {
			self.titleTextView.text = self.model?.title
			self.textTextView.text = self.model?.text
		}
	}

	// MARK:- UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		defer {
			self.presenter = EditionPresenter(view: self, identifier: self.noteIdentifier!)
			self.presenter?.prepareView()
		}
		
		self.title = "Edit Note"
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.navigationItem.setHidesBackButton(true, animated: false)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEdition))

		self.view.backgroundColor = ColorTheme.lightBackground

		self.titleLabelView.backgroundColor = UIColor.clear
		self.titleLabel.textColor = ColorTheme.darkText
		self.titleLabel.text = "Title".uppercased()
		
		self.textLabelView.backgroundColor = UIColor.clear
		self.textLabel.textColor = ColorTheme.darkText
		self.textLabel.text = "Text".uppercased()
		
		self.titleTextView.isScrollEnabled = false
		self.titleTextView.textContainerInset = self.titleLabelView.layoutMargins
		self.titleTextView.tag = EditionFieldIdentifier.title.rawValue
		self.titleTextView.delegate = self
		
		self.textTextView.isScrollEnabled = false
		self.textTextView.textContainerInset = self.textLabelView.layoutMargins
		self.textTextView.tag = EditionFieldIdentifier.text.rawValue
		self.textTextView.delegate = self

		self.saveButton.title = "Save"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setToolbarHidden(false, animated: animated)
	}

	// MARK:- EditionViewController

	@IBAction func saveNote(_ sender: Any) {
		if let model = self.model {
			self.saveButton.isEnabled = false
			self.presenter?.saveNote(model: model)
		}
	}

	@objc func cancelEdition() {
		if let model = model,
		   self.presenter?.canSafelyCancel(model: model) ?? false {
			self.presenter?.cancelEdition()
		}
		else {
			let alertController = UIAlertController(title: "Cancel", message: "Are you sure you wish to leave without saving?", preferredStyle: .alert)
			let cancelAction    = UIAlertAction(title: "No", style: .default, handler: nil)
			let confirmAction = UIAlertAction(title: "Yes", style: .destructive) {
				result -> Void in
				self.presenter?.cancelEdition()
			}
			alertController.addAction(cancelAction)
			alertController.addAction(confirmAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	@objc func dismissKeyboard() {
		self.view.endEditing(true)
	}
}

extension EditionViewController: UITextViewDelegate {
	// MARK:- UITextViewDelegate
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		let toolbar       = UIToolbar()
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton    = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
		
		toolbar.items = [flexibleSpace, doneButton]
		toolbar.sizeToFit()
		
		textView.inputAccessoryView = toolbar
		
		return true
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.tag == EditionFieldIdentifier.title.rawValue {
			self.model?.title = textView.text
		}
		else if textView.tag == EditionFieldIdentifier.text.rawValue {
			self.model?.text = textView.text
		}
	}
}

extension EditionViewController: EditionView {
	// MARK:- EditionView

	func display(model: EditionViewModel) {
		self.model = model
	}
	
	func endEdition(with result: EditionEndResult) {
		if result == .success {
			self.navigationController?.popViewController(animated: true)
		}
		else if result == .cancel {
			self.navigationController?.popViewController(animated: true)
		}
		else if result == .accessDenied {
			self.showAccessDeniedAlert()
		}
	}
	
	private func showAccessDeniedAlert() {
		let alertController = UIAlertController(title: "Access Denied", message: "You do not have permission to edit this note.", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default) {
			result -> Void in
			self.navigationController?.popViewController(animated: true)
		}
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
}
