import UIKit

class ListingViewController: UITableViewController {
	// MARK:- Outlets

	@IBOutlet private weak var createButton: UIBarButtonItem!
	@IBOutlet private weak var settingsButton: UIBarButtonItem!

	// MARK: Properties

	private var     presenter: ListingPresenter?
	fileprivate var models = [ListingViewModel]()

	// MARK: UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		defer {
			self.presenter = ListingPresenter(view: self)
		}
		
		self.title = "Notes"

		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 80

		self.createButton.title = "Create"
		self.createButton.target = self
		self.createButton.action = #selector(createNote)
		
		self.settingsButton.title = "Settings"
		self.settingsButton.target = self
		self.settingsButton.action = #selector(editSettings)
		
		self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setToolbarHidden(false, animated: animated)
		
		self.presenter?.refreshListing()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ListingToDetails",
		   let destination = segue.destination as? DetailsViewController,
		   let noteIndex = self.tableView.indexPathForSelectedRow?.row {
			destination.noteIdentifier = self.models[noteIndex].identifier
		}
		
	}

	// MARK: UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.models.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell  = self.tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell") as! ListingTableViewCell
		let model = self.models[indexPath.row]

		cell.model = model

		return cell
	}

	// MARK:- ListingViewController
	
	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
		self.presenter?.refreshListing()
	}
	
	@objc func createNote() {
		self.performSegue(withIdentifier: "ListingToCreation", sender: nil)
	}
	
	@objc func editSettings() {
		self.performSegue(withIdentifier: "ListingToSettings", sender: nil)
	}
}

extension ListingViewController: ListingView {
	// MARK:- ListingView

	func update(with models: [ListingViewModel]) {
		self.models = models
		self.refreshControl?.endRefreshing()
		self.tableView.reloadData()
	}
}
