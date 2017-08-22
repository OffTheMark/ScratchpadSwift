import Foundation
import Firebase

enum CreationFieldIdentifier: FieldIdentifier {
	case title
	case text
}

class CreationPresenter {

	// MARK: Properties

	weak private var view: CreationView?
	private let database: Database
	private let authentication: Auth

	// MARK: CreationPresenter

	init(view: CreationView, database: Database = Database.database(), authentication: Auth = Auth.auth()) {
		self.view = view
		self.database = database
		self.authentication = authentication
	}

	func prepareView() {
		self.view?.display(model: CreationViewModel())
	}

	func createNote(model: CreationViewModel) {
		let validationErrors = self.validate(model: model)

		if validationErrors.isEmpty, let userIdentifier = self.authentication.currentUser?.uid {
			let noteReference = self.database.reference(withPath: "notes").childByAutoId()
			let userReference = self.database.reference(withPath: "users").child(userIdentifier)
			
			let noteIdentifier = noteReference.key
			let note           = Note(identifier: noteIdentifier, owner: userIdentifier, title: model.title, text: model.text)
			
			userReference.setValue(note.toDictionary())
			userReference.child(noteIdentifier).setValue(true)
			
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
