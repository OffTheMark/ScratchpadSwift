import Foundation

protocol CreationView: class {
	func display(viewModel model: CreationViewModel)
	
	func endCreation()
}
