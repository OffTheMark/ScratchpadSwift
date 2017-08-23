import Foundation
import UIKit

enum SettingsTableViewSection: Int {
	case account = 0
}

class SettingsViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet weak var tableView: UITableView!
	
	
	// MARK:- Properties
	
	

	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		self.title = "Settings"
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.tableView.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setToolbarHidden(true, animated: animated)
	}
}

extension SettingsViewController: UITableViewDataSource {
	// MARK:- UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var title: String? = nil
		
		if section == SettingsTableViewSection.account.rawValue {
			title =  "Account"
		}
		
		return title
	}
}

extension SettingsViewController: SettingsView {
	// MARK:- SettingsView
	
	func display(model: SettingsViewModel) {
		
	}
	
	func endSettings() {
		self.navigationController?.popViewController(animated: true)
	}
}
