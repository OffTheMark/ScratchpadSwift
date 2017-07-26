import Foundation
import UIKit

class TextFieldView: UIView {
	// MARK:- Outlets

	@IBOutlet fileprivate weak var titleLabel:      UILabel!
	@IBOutlet fileprivate weak var textView:        UITextView!
	@IBOutlet fileprivate weak var errorsStackView: UIStackView!
	@IBOutlet fileprivate weak var errorsView:      UIView!

	// MARK:- Properties

	fileprivate var delegate:   TextFieldViewDelegate?
	fileprivate var identifier: FieldIdentifier?
	var title: String? {
		set(newTitle) {
			self.titleLabel.text = newTitle?.uppercased()
		}
		get {
			return self.titleLabel.text
		}
	}
	var text:  String {
		set(newText) {
			self.textView.text = newText
		}
		get {
			return self.textView.text
		}
	}
	var errors = [ValidationError]() {
		willSet(newErrors) {
			let oldErrors = self.errors
			
			self.animateErrorsView(oldErrors: oldErrors, newErrors: newErrors)
		}
	}

	// MARK:- UIView

	override func awakeFromNib() {
		super.awakeFromNib()

		self.titleLabel.textColor = ColorTheme.darkText

		self.textView.delegate = self
		self.textView.isScrollEnabled = false

		self.errorsView.isHidden = true
	}

	// MARK:- TextFieldView

	static func make(identifier: FieldIdentifier, title: String, text: String? = nil, delegate: TextFieldViewDelegate) -> TextFieldView {
		let fieldView = UINib(nibName: "TextFieldView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TextFieldView

		fieldView.identifier = identifier
		fieldView.title = title
		if let text = text {
			fieldView.text = text
		}
		fieldView.delegate = delegate

		return fieldView
	}

	private func makeLabelForError(_ error: ValidationError) -> UILabel {
		let label = UILabel()
		label.text = error.description
		label.textColor = ColorTheme.errorText
		label.font = UIFont.systemFont(ofSize: 13)
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping

		return label
	}
	
	private func animateErrorsView(oldErrors: [ValidationError], newErrors: [ValidationError]) {
		guard oldErrors != newErrors else {
			return
		}
		
		if oldErrors.isEmpty && !newErrors.isEmpty  {
			self.showErrors(errors: newErrors, animated: true)
		}
		else if !oldErrors.isEmpty && !newErrors.isEmpty {
			self.showErrors(errors: newErrors, animated: false)
		}
		else {
			self.hideErrors(animated: true)
		}
	}
	
	private func showErrors(errors: [ValidationError], animated: Bool) {
		self.errorsStackView.removeAllArrangedSubviews()
		
		var errorLabels = [UILabel]()
		for error in errors {
			errorLabels.append(self.makeLabelForError(error))
		}
		let showErrorsBlock = {
			self.titleLabel.textColor = ColorTheme.errorText
			self.errorsView.isHidden = false
			for errorLabel in errorLabels {
				self.errorsStackView.addArrangedSubview(errorLabel)
			}
		}
		
		if animated {
			UIView.animate(withDuration: 0.2) {
				showErrorsBlock()
			}
		}
		else {
			showErrorsBlock()
		}
	}
	
	private func hideErrors(animated: Bool) {
		self.errorsStackView.removeAllArrangedSubviews()
		
		let hideErrorsBlock = {
			self.titleLabel.textColor = ColorTheme.darkText
			self.errorsView.isHidden = true
		}
		
		if animated {
			UIView.animate(withDuration: 0.2) {
				hideErrorsBlock()
			}
		}
		else {
			hideErrorsBlock()
		}
	}

	func dismissKeyboard() {
		self.textView.endEditing(true)
	}

	func giveFocus() {
		self.textView.becomeFirstResponder()
	}
}

extension TextFieldView: UITextViewDelegate {
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

	func textViewDidChange(_ textView: UITextView) {
		self.delegate?.textDidChange(identifier: self.identifier!, text: textView.text)
	}
}

protocol TextFieldViewDelegate {
	func textDidChange(identifier: FieldIdentifier, text: String)
}
