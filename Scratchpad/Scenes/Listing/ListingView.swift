import Foundation
import UIKit

protocol ListingView: class {
	func update(with viewModels: [ListingViewModel])
}

struct ListingViewModel {
	let identifier:  NoteIdentifier
	let title:       String
	let lastUpdated: String
}
