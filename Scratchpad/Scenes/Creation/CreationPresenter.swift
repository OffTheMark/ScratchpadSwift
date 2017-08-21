import Foundation
import Firebase

enum CreationFieldIdentifier: FieldIdentifier {
	case title
	case text
}

class CreationPresenter {

	// MARK: Properties

	weak private var view: CreationView?
	private let notesReference: DatabaseReference

	// MARK: CreationPresenter

	init(view: CreationView) {
		self.view = view
		self.notesReference = Database.database().reference(withPath: "notes")
	}

	func prepareView() {
		self.view?.display(model: CreationViewModel())
	}

	func createNote(model: CreationViewModel) {
		let validationErrors = self.validate(model: model)

		if validationErrors.isEmpty, let userIdentifier = Auth.auth().currentUser?.uid {
			let childReference = self.notesReference.childByAutoId()
			let note           = Note(identifier: childReference.key, owner: userIdentifier, title: model.title, text: model.text)
			childReference.setValue(note.toDictionary())
			self.view?.endCreation()
		}
		else {
			self.view?.display(errors: validationErrors)
			return
		}
	}

	func canSafelyCancel(model: CreationViewModel) -> Bool {
		return model.title.isEmpty && model.text.isEmpty
	}

	func cancelCreation() {
		self.view?.endCreation()
	}

	private func validate(model: CreationViewModel) -> [ValidationError] {
		var errors = [ValidationError]()

		if model.title.isEmpty {
			errors.append(ValidationError(field: CreationFieldIdentifier.title.rawValue, description: "Title is required."))
		}

		return errors
	}
}
