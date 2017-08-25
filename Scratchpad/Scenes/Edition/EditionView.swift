import Foundation

protocol EditionView: class {
	func display(model: EditionViewModel)

	func endEdition(with result: EditionEndResult)
}

enum EditionEndResult {
	case success
	case cancel
	case accessDenied
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
