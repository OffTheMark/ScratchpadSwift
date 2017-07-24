import Foundation

protocol EditionView: class {
	func display(model: EditionViewModel)

	func display(errors: [ValidationError])

	func endEdition()
}

struct EditionViewModel {
	var identifier: NoteIdentifier
	var title:      String
	var text:       String
}
