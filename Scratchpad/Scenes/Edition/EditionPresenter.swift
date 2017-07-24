import Foundation
import Firebase

enum EditionFieldIdentifier: FieldIdentifier {
	case title
	case text
}

class EditionPresenter {
	// MARK:- Properties

	weak private var view: EditionView?
	private let noteReference:   DatabaseReference
	private var referenceHandle: UInt?
	private var initialModel:    EditionViewModel?

	init(view: EditionView, identifier: NoteIdentifier) {
		self.view = view
		self.noteReference = Database.database()
									 .reference(withPath: "notes")
									 .child(identifier)
		self.noteReference.observeSingleEvent(of: .value, with: {
			snapshot in
			if let value = snapshot.value as? [String:Any] {
				let note  = Note.make(from: value)
				let model = self.convert(note: note)
				self.initialModel = model
				self.view?.display(model: model)
			}
		})
	}

	deinit {
		if let handle = self.referenceHandle {
			self.noteReference.removeObserver(withHandle: handle)
		}
	}

	func saveNote(model: EditionViewModel) {
		let validationErrors = self.validate(model: model)

		if validationErrors.isEmpty {
			let updatedDate = Date()

			self.noteReference.child("title")
							  .setValue(model.title)
			self.noteReference.child("text")
							  .setValue(model.text)
			self.noteReference.child("updatedAt")
							  .setValue(updatedDate.timeIntervalSince1970)

			self.view?.endEdition()
		}
		else {
			self.view?.display(errors: validationErrors)
		}
	}

	func canSafelyCancel(model: EditionViewModel) -> Bool {
		guard let initialModel = self.initialModel else {
			return false
		}

		return initialModel == model
	}

	func cancelEdition() {
		self.view?.endEdition()
	}

	private func convert(note: Note) -> EditionViewModel {
		return EditionViewModel(
				identifier: note.identifier,
				title: note.title,
				text: note.text
		)
	}

	private func validate(model: EditionViewModel) -> [ValidationError] {
		var errors = [ValidationError]()

		if model.title.isEmpty {
			errors.append(ValidationError(field: EditionFieldIdentifier.title.rawValue, description: "Title is required."))
		}

		return errors
	}
}
