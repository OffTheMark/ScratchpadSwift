import Foundation
import UIKit

protocol ListingView: class {
	func update(with viewModels: [ListingViewModel])
}
