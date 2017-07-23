import Foundation

protocol CreationView: class {
	func display(model: CreationViewModel)
	
	func display(errors: [ValidationError])
	
	func endCreation()
}
