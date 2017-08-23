import Foundation

protocol SettingsView: class {
	func display(model: SettingsViewModel)
	
	func endSettings()
}

struct SettingsViewModel {
	
}
