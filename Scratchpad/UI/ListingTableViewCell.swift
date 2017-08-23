import Foundation
import UIKit

class ListingTableViewCell: UITableViewCell {
	// MARK:- Outlets

	@IBOutlet weak var titleLabel:       UILabel!
	@IBOutlet weak var createdDateLabel: UILabel!
	@IBOutlet weak var updatedDateLabel: UILabel!

	// MARK:- Properties

	var model: ListingViewModel? {
		didSet {
			if let model = self.model {
				self.titleLabel.text = model.title
				self.createdDateLabel.text = "Created on \(model.createdDate)"
				self.updatedDateLabel.text = "Last updated on \(model.updatedDate)"
			}
		}
	}

	// MARK:- UIView

	override func awakeFromNib() {
		super.awakeFromNib()

		self.titleLabel.textColor = ColorTheme.blackText
		self.createdDateLabel.textColor = ColorTheme.darkText
		self.updatedDateLabel.textColor = ColorTheme.darkText
	}
}
