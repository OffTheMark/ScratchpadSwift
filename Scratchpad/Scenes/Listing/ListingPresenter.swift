import Foundation
import Firebase

class ListingPresenter {

	// MARK: Properties

	private weak var view: ListingView?
	private let database: Database
	private let authentication: Auth
	
	// MARK: ListingPresenter

	init(view: ListingView, database: Database = Database.database(), authentication: Auth = Auth.auth()) {
		self.view = view
		self.database = database
		self.authentication = authentication
	}
	
	func refreshListing() {
		if let userIdentifier = self.authentication.currentUser?.uid {
			self.database
				.reference(withPath: "users")
				.child(userIdentifier)
				.observeSingleEvent(of: .value, with: {
					userNotesSnapshot in
					
					var noteIdentifiers = [NoteIdentifier]()
					
					for item in userNotesSnapshot.children {
						if let noteIdentifierSnapshot = item as? DataSnapshot {
							noteIdentifiers.append(noteIdentifierSnapshot.key)
						}
					}
					
					if !noteIdentifiers.isEmpty {
						self.database
							.reference(withPath: "notes")
							.queryOrdered(byChild: "owner")
							.queryEqual(toValue: userIdentifier)
							.observeSingleEvent(of: .value, with: {
								notesSnapshot in
								
								var notes = [Note]()
								
								for item in notesSnapshot.children {
									if let noteSnapshot = item as? DataSnapshot,
										let value = noteSnapshot.value as? [String:Any] {
										let note = Note.make(from: value)
										notes.append(note)
									}
								}
								
								notes.sort {
									(leftNote, rightNote) -> Bool in
									return leftNote.updatedDate > rightNote.updatedDate
								}
								
								self.view?.update(with: self.convert(notes: notes))
							}, withCancel: {
								error in
								print("Notes query")
								print(error.localizedDescription)
							})
					}
					else {
						self.view?.update(with: [])
					}
				}, withCancel: {
					error in
					print("Users query")
					print(error.localizedDescription)
				})
		}
	}

	private func convert(notes: [Note]) -> [ListingViewModel] {
		let formatter = DateFormatter.cached(withFormat: "MM/dd/yyyy")
		return notes.map {
			note in
			ListingViewModel(
					identifier: note.identifier,
					title: note.title,
					updatedDate: formatter.string(from: note.updatedDate),
					createdDate: formatter.string(from: note.createdDate)
			)
		}
	}
}
