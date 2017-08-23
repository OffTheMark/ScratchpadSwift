import Foundation
import Firebase

class SettingsPresenter {
	// MARK:- Properties
	
	private weak var view: SettingsView?
	private let authentication: Auth
	
	// MARK:- SettingsPresenter
	
	init(view: SettingsView, authentication: Auth = Auth.auth()) {
		self.view = view
		self.authentication = authentication
	}
	
	func prepareView() {
		if let userEmail = self.authentication.currentUser?.email {
			self.view?.display(model: SettingsViewModel(userEmail: userEmail))
		}
	}
	
	func signOut() {
		do {
			try self.authentication.signOut()
			self.view?.endSignOut()
		}
		catch {}
	}
}
