import Foundation
import UIKit

class CreationTableViewController: UITableViewController {
	
	// MARK: Outlets
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	// MARK: Properties
	
	var presenter: CreationPresenter?
	var viewModel: CreationViewModel?
	
	// MARK: UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Create Note"
		
		self.tableView.estimatedRowHeight = 50
		self.tableView.rowHeight = UITableViewAutomaticDimension
		
		self.presenter = CreationPresenter(view: self)
		self.presenter?.prepareView()
	}
	
	// MARK: UITableViewDataSource
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Title"
		}
		else {
			return "Text"
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextViewCell") as! TextViewTableViewCell
		cell.textView.delegate = self
		cell.textView.tag = indexPath.section
		return cell
	}
	
	// MARK: CreationTableViewController
	
	@IBAction func saveNote(_ sender: UIBarButtonItem) {
		if let model = self.viewModel {
			self.saveButton.isEnabled = false
			self.presenter?.createNote(model: model)
		}
	}
}

// MARK:- UITextViewDelegate

extension CreationTableViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		let currentOffSet = self.tableView.contentOffset
		UIView.setAnimationsEnabled(false)
		self.tableView.beginUpdates()
		self.tableView.endUpdates()
		UIView.setAnimationsEnabled(true)
		self.tableView.setContentOffset(currentOffSet, animated: false)
		
		if textView.tag == 0 {
			self.viewModel?.title = textView.text
		}
		else if textView.tag == 1 {
			self.viewModel?.text = textView.text
		}
	}
}

// MARK:- CreationView

extension CreationTableViewController: CreationView {
	func set(viewModel model: CreationViewModel) {
		self.viewModel = model
	}
	
	func endCreation() {
		self.navigationController?.popViewController(animated: true)
	}
}

class TextViewTableViewCell: UITableViewCell {
	
	// MARK: Outlets
	
	@IBOutlet weak var textView: UITextView!
}
