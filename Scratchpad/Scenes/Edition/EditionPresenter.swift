import Foundation
import Firebase

enum EditionFieldIdentifier: FieldIdentifier {
	case title
	case text
}

class EditionPresenter {
	// MARK:- Properties

	weak private var view: EditionView?
	private let noteIdentifier: NoteIdentifier
	private let database: Database
	private let authentication: Auth
	private var initialModel: EditionViewModel?

	init(view: EditionView, identifier: NoteIdentifier, database: Database = Database.database(), authentication: Auth = Auth.auth()) {
		self.view = view
		self.noteIdentifier = identifier
		self.database = database
		self.authentication = authentication
	}
	
	func prepareView() {
		self.database
			.reference(withPath: "notes")
			.child(self.noteIdentifier)
			.observeSingleEvent(of: .value, with: {
				snapshot in
				if let value = snapshot.value as? [String:Any] {
					let note = Note.make(from: value)
					
					guard let userIdentifier = self.authentication.currentUser?.uid,
						note.owner == userIdentifier
					else {
						self.view?.endEdition(with: .accessDenied)
						return
					}
					
					let model = self.convert(note: note)
					self.initialModel = model
					self.view?.display(model: model)
				}
			}, withCancel: {
				error in
				print(error.localizedDescription)
			})
	}

	func saveNote(model: EditionViewModel) {
		let noteReference = self.database.reference(withPath: "notes").child(self.noteIdentifier)
		let updatedDate = Date()

		noteReference.child("title").setValue(model.title)
		noteReference.child("text").setValue(model.text)
		noteReference.child("updatedAt").setValue(updatedDate.timeIntervalSince1970)
		
		self.view?.endEdition(with: .success)
	}

	func canSafelyCancel(model: EditionViewModel) -> Bool {
		guard let initialModel = self.initialModel else {
			return false
		}

		return initialModel == model
	}

	func cancelEdition() {
		self.view?.endEdition(with: .cancel)
	}

	private func convert(note: Note) -> EditionViewModel {
		return EditionViewModel(
				identifier: note.identifier,
				title: note.title,
				text: note.text
		)
	}
}
