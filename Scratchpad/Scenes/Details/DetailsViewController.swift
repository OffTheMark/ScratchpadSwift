import Foundation
import UIKit

class DetailsViewController: UIViewController {

	// MARK: Properties

	var noteIdentifier: String?
	var presenter:      DetailsPresenter?

	@IBOutlet weak var titleLabel:   UILabel!
	@IBOutlet weak var createdLabel: UILabel!
	@IBOutlet weak var updatedLabel: UILabel!
	@IBOutlet weak var textTextView: UITextView!

	// MARK: UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		self.presenter = DetailsPresenter(view: self, for: self.noteIdentifier!)
	}

	internal func setupView(with viewModel: DetailsViewModel) {
		self.titleLabel.text = viewModel.title
		self.createdLabel.text = "Created on \(viewModel.created)"
		self.updatedLabel.text = "Last updated on \(viewModel.lastUpdated)"
		self.textTextView.text = viewModel.text
	}
}

// MARK:- DetailsView

extension DetailsViewController: DetailsView {

	func update(viewModel: DetailsViewModel) {
		self.setupView(with: viewModel)
	}
}
