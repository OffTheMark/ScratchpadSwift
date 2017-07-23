import Foundation

protocol DetailsView: NSObjectProtocol {
	func update(viewModel: DetailsViewModel)

	func endDetails()
}
