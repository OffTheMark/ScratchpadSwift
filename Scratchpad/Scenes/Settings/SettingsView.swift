import Foundation

protocol SettingsView: class {
	func display(model: SettingsViewModel)
	
	func endSignOut()
}

struct SettingsViewModel {
	let userEmail: String
}
