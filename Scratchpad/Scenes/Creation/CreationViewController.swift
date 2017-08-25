import Foundation
import UIKit

class CreationViewController: UIViewController {
	// MARK:- Outlets

	@IBOutlet fileprivate weak var saveButton: UIBarButtonItem!
	@IBOutlet fileprivate var contentView: UIView!
	@IBOutlet fileprivate weak var fieldsStackView: UIStackView!
	@IBOutlet private weak var titleLabelView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var titleTextView: UITextView!
	@IBOutlet private weak var textLabelView: UIView!
	@IBOutlet private weak var textLabel: UILabel!
	@IBOutlet private weak var textTextView: UITextView!

	// MARK:- Properties

	private var     presenter:          CreationPresenter?
	fileprivate var model:              CreationViewModel? {
		didSet {
			self.titleTextView.text = self.model?.title
			self.textTextView.text = self.model?.text
		}
	}

	// MARK:- UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		defer {
			self.presenter = CreationPresenter(view: self)
			self.presenter?.prepareView()
		}

		self.title = "Create Note"
		self.automaticallyAdjustsScrollViewInsets = false

		self.navigationItem.setHidesBackButton(true, animated: false)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCreation))

		self.view.backgroundColor = ColorTheme.lightBackground

		self.titleLabelView.backgroundColor = UIColor.clear
		self.titleLabel.font = UIFont.systemFont(ofSize: 13)
		self.titleLabel.textColor = ColorTheme.darkText
		self.titleLabel.text = "Title".uppercased()
		
		self.textLabelView.backgroundColor = UIColor.clear
		self.textLabel.font = UIFont.systemFont(ofSize: 13)
		self.textLabel.textColor = ColorTheme.darkText
		self.textLabel.text = "Text".uppercased()
		
		self.titleTextView.tag = CreationFieldIdentifier.title.rawValue
		self.titleTextView.delegate = self
		
		self.textTextView.tag = CreationFieldIdentifier.text.rawValue
		self.textTextView.delegate = self
		
		self.saveButton.title = "Save"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setToolbarHidden(false, animated: animated)
	}

	// MARK:- CreationViewController

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

extension CreationViewController: UITextViewDelegate {
	// MARK:- UITextViewDelegate
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.tag == CreationFieldIdentifier.title.rawValue {
			self.model?.title = textView.text
		}
		else if textView.tag == CreationFieldIdentifier.text.rawValue {
			self.model?.text = textView.text
		}
	}
}

extension CreationViewController: CreationView {
	// MARK:- CreationView

	func display(model: CreationViewModel) {
		self.model = model
	}
	
	func endCreation() {
		self.navigationController?.popViewController(animated: true)
	}
}
