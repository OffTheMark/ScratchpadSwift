import Foundation
import UIKit
import SwiftMessages

enum SettingsTableViewSection: Int {
	case account = 0
}

enum SettingsAccountSectionRow: Int {
	case email
	case signOut
}

class SettingsViewController: UIViewController {
	// MARK:- Outlets
	
	@IBOutlet fileprivate weak var tableView: UITableView!
	
	// MARK:- Properties
	
	fileprivate var presenter: SettingsPresenter?
	fileprivate var model: SettingsViewModel?

	// MARK:- UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		defer {
			self.presenter = SettingsPresenter(view: self)
			self.presenter?.prepareView()
		}
		
		self.title = "Settings"
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
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
		if indexPath.section == SettingsTableViewSection.account.rawValue {
			let accountCell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell")!
			
			if indexPath.row == SettingsAccountSectionRow.email.rawValue {
				accountCell.textLabel?.text = "Signed in as"
				accountCell.detailTextLabel?.text = self.model?.userEmail
			}
			else if indexPath.row == SettingsAccountSectionRow.signOut.rawValue {
				accountCell.textLabel?.text = "Sign out"
				accountCell.detailTextLabel?.text = nil
			}
			
			return accountCell
		}
		else {
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var title: String? = nil
		
		if section == SettingsTableViewSection.account.rawValue {
			title =  "Account"
		}
		
		return title
	}
}

extension SettingsViewController: UITableViewDelegate {
	// MARK:- UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == SettingsTableViewSection.account.rawValue {
			if indexPath.row == SettingsAccountSectionRow.signOut.rawValue {
				self.presenter?.signOut()
			}
		}
	}
}

extension SettingsViewController: SettingsView {
	// MARK:- SettingsView
	
	func display(model: SettingsViewModel) {
		self.model = model
		self.tableView.reloadData()
	}
	
	func endSignOut() {
		if let window = self.view.window {
			UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
				window.rootViewController = SignInViewController.make()
				window.makeKeyAndVisible()
			}, completion: {
				_ in
				self.showSignOutMessage()
			})
		}
	}
	
	private func showSignOutMessage() {
		let view = MessageView.viewFromNib(layout: .MessageView)
		var config = SwiftMessages.Config()
		
		config.presentationStyle = .bottom
		config.ignoreDuplicates = false
		
		view.configureTheme(.success)
		view.configureDropShadow()
		view.configureContent(
			title: nil,
			body: "You have been signed out from your account.",
			iconImage: nil,
			iconText: nil,
			buttonImage: nil,
			buttonTitle: nil,
			buttonTapHandler: nil)
		view.button?.isHidden = true
		
		SwiftMessages.show(config: config, view: view)
	}
}
