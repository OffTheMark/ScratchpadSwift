import Foundation
import UIKit

class CreationViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var tableView: UITableView!
	
	// MARK:- Properties
	
	fileprivate var presenter: CreationPresenter?
	fileprivate var viewModel: CreationViewModel? {
		didSet {
			self.saveButton.isEnabled = true
		}
	}
	fileprivate var validationErrors: [ValidationError]? {
		didSet {
			if let errors = self.validationErrors, !errors.isEmpty {
				self.saveButton.isEnabled = false
			}
			else {
				self.saveButton.isEnabled = true
			}
		}
	}
	
	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defer { self.presenter?.prepareView() }
		
		self.title = "Create Note"
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.tableView.estimatedRowHeight = 50
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.allowsSelection = false
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TextViewTableViewCell")
		
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

extension CreationViewController: UITableViewDataSource {
	// MARK:- UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard section < 2 else {
			return nil
		}
		
		if section == 0 {
			return "Title"
		}
		else {
			return "Text"
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell") as! TextViewTableViewCell
		let fieldIdentifier: CreationFieldIdentifier
		if indexPath.section == 0 {
			fieldIdentifier = .title
		}
		else {
			fieldIdentifier = .text
		}
		
		cell.textView.delegate = self
		cell.textView.tag = fieldIdentifier.rawValue
		return cell
	}
}

extension CreationViewController: UITableViewDelegate {
	// MARK:- UITableViewDelegate
	
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
		let currentOffSet = self.tableView.contentOffset
		UIView.setAnimationsEnabled(false)
		self.tableView.beginUpdates()
		self.tableView.endUpdates()
		UIView.setAnimationsEnabled(true)
		self.tableView.setContentOffset(currentOffSet, animated: false)
		
		if textView.tag == CreationFieldIdentifier.title.rawValue {
			self.viewModel?.title = textView.text
		}
		else if textView.tag == CreationFieldIdentifier.text.rawValue {
			self.viewModel?.text = textView.text
		}
	}
}

extension CreationViewController: CreationView {
	// MARK:- CreationView
	
	func display(model: CreationViewModel) {
		self.viewModel = model
	}
	
	func display(errors: [ValidationError]) {
		self.validationErrors = errors
	}
	
	func endCreation() {
		self.navigationController?.popViewController(animated: true)
	}
}
