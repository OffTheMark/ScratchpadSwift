import Foundation
import UIKit

class TextFieldView: UIView {
	// MARK:- Outlets
	
	@IBOutlet fileprivate weak var titleLabel: UILabel!
	@IBOutlet fileprivate(set) weak var textView: UITextView!
	@IBOutlet fileprivate weak var errorsStackView: UIStackView!
	@IBOutlet fileprivate weak var errorsView: UIView!
	
	// MARK:- Properties
	
	fileprivate var delegate: TextFieldViewDelegate?
	fileprivate var identifier: FieldIdentifier?
	var titleText: String? {
		didSet {
			self.titleLabel.text = self.titleText?.uppercased()
		}
	}
	var errors: [ValidationError]? {
		didSet {
			self.errorsStackView.removeAllArrangedSubviews()
			
			if let errors = self.errors, !errors.isEmpty {
				for error in errors {
					self.errorsStackView.addArrangedSubview(self.makeLabelForError(error))
				}
				self.titleLabel.textColor = UIColor.red
				self.errorsView.isHidden = false
			}
			else {
				self.titleLabel.textColor = UIColor.darkGray
				self.errorsView.isHidden = true
			}
		}
	}
	
	// MARK:- UIView
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.titleLabel.textColor = UIColor.darkGray
		
		self.textView.delegate = self
		self.textView.isScrollEnabled = false
		
		self.errorsView.isHidden = true
	}
	
	// MARK:- TextFieldView
	
	static func make(identifier: FieldIdentifier, titleText: String, contentText: String? = nil, delegate: TextFieldViewDelegate) -> TextFieldView {
		let fieldView = UINib(nibName: "TextFieldView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TextFieldView
		
		fieldView.identifier = identifier
		fieldView.titleText = titleText
		fieldView.textView.text = contentText
		fieldView.delegate = delegate
		
		return fieldView
	}
	
	private func makeLabelForError(_ error: ValidationError) -> UILabel {
		let label = UILabel()
		label.text = error.description
		label.textColor = UIColor.red
		label.font = UIFont.systemFont(ofSize: 13)
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		
		return label
	}
	
	func dismissKeyboard() {
		self.textView.endEditing(true)
	}
}

extension TextFieldView: UITextViewDelegate {
	// MARK:- UITextViewDelegate
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		let toolbar = UIToolbar()
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
		
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
