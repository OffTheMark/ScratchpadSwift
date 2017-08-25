import Foundation

protocol CreationView: class {
	func display(model: CreationViewModel)

	func endCreation()
}

struct CreationViewModel {
	var title: String
	var text:  String

	init(title: String = "", text: String = "") {
		self.title = title
		self.text = text
	}
}
