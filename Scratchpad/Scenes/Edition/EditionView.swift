import Foundation

protocol EditionView: class {
	func display(model: EditionViewModel)

	func display(errors: [ValidationError])

	func endEdition()
}

struct EditionViewModel: Equatable {
	var identifier: NoteIdentifier
	var title:      String
	var text:       String
}

func ==(left: EditionViewModel, right: EditionViewModel) -> Bool {
	return left.identifier.hashValue == right.identifier.hashValue &&
		left.title.hashValue == right.title.hashValue &&
		left.text.hashValue == right.text.hashValue
}
