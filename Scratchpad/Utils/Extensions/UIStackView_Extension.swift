import Foundation
import UIKit

extension UIStackView {
	func removeAllArrangedSubviews() {
		for view in self.arrangedSubviews {
			self.removeArrangedSubview(view)
			view.removeFromSuperview()
		}
	}
}
