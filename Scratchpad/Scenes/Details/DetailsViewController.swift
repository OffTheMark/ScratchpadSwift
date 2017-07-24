import Foundation
import UIKit

class DetailsViewController: UIViewController {
	// MARK:- Properties

	var noteIdentifier: String?
	fileprivate var presenter: DetailsPresenter?

	@IBOutlet weak fileprivate var titleLabel:   UILabel!
	@IBOutlet weak fileprivate var createdLabel: UILabel!
	@IBOutlet weak fileprivate var updatedLabel: UILabel!
	@IBOutlet weak fileprivate var textTextView: UITextView!
	@IBOutlet weak fileprivate var editButton: UIBarButtonItem!
	@IBOutlet weak fileprivate var deleteButton: UIBarButtonItem!

	// MARK:- UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		self.editButton.title = "Edit"
		
		self.deleteButton.title = "Delete"
		
		self.presenter = DetailsPresenter(view: self, for: self.noteIdentifier!)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowEdition",
			let destination = segue.destination as? EditionViewController {
			destination.noteIdentifier = self.noteIdentifier
		}
	}

	//MARK:- DetailsViewController

	@IBAction func deleteNote(_ sender: Any) {
		let alertController = UIAlertController(title: "Delete Note", message: "Are you sure you wish to delete this note?", preferredStyle: .alert)
		let cancelAction    = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		let confirmAction = UIAlertAction(title: "Yes", style: .default) {
			result -> Void in
			self.presenter?.deleteNote()
		}
		alertController.addAction(cancelAction)
		alertController.addAction(confirmAction)
		self.present(alertController, animated: true, completion: nil)
	}
}

extension DetailsViewController: DetailsView {
	// MARK:- DetailsView

	func update(viewModel: DetailsViewModel) {
		self.titleLabel.text = viewModel.title
		self.createdLabel.text = "Created on \(viewModel.created)"
		self.updatedLabel.text = "Last updated on \(viewModel.lastUpdated)"
		self.textTextView.text = viewModel.text
	}

	func endDetails() {
		self.navigationController?.popViewController(animated: true)
	}
}
