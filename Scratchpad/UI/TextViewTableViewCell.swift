import Foundation
import UIKit

class TextViewTableViewCell: UITableViewCell {
	// MARK: Outlets
	
	@IBOutlet weak var textView: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.textView.isScrollEnabled = false
	}
}
