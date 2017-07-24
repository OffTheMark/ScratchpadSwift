import UIKit

class ListingViewController: UITableViewController {
	// MARK:- Outlets
	
	@IBOutlet weak var createButton: UIBarButtonItem!
	
	// MARK: Properties

	private var presenter: ListingPresenter?
	fileprivate var viewModels = [ListingViewModel]()

	// MARK: UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Notes"
		
		self.createButton.title = "Create"
		
		self.presenter = ListingPresenter(view: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetails",
			let destination = segue.destination as? DetailsViewController,
			let noteIndex = self.tableView.indexPathForSelectedRow?.row {
			destination.noteIdentifier = self.viewModels[noteIndex].identifier
		}
	}

	// MARK: UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModels.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell      = self.tableView.dequeueReusableCell(withIdentifier: "NoteCell")!
		let viewModel = self.viewModels[indexPath.row]

		cell.textLabel?.text = viewModel.title
		cell.detailTextLabel?.text = viewModel.lastUpdated

		return cell
	}
}

extension ListingViewController: ListingView {
	// MARK:- ListingView

	func update(with viewModels: [ListingViewModel]) {
		self.viewModels = viewModels
		self.tableView.reloadData()
	}
}
