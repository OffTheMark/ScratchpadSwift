import Foundation
import Firebase

class DetailsPresenter {

	// MARK: Properties

	weak private var view: DetailsView?
	private let noteReference:   DatabaseReference
	private var referenceHandle: UInt?

	// MARK: DetailsPresenter

	init(view: DetailsView, for identifier: String) {
		self.view = view
		self.noteReference = Database.database()
									 .reference(withPath: "notes")
									 .child(identifier)
		self.referenceHandle = self.noteReference.observe(.value, with: {
			snapshot in
			if let value = snapshot.value as? [String:Any] {
				let note = Note.make(from: value)
				self.view?.update(viewModel: self.convert(note: note))
			}
		})
	}

	deinit {
		if let handle = self.referenceHandle {
			self.noteReference.removeObserver(withHandle: handle)
		}
	}

	func deleteNote() {
		self.noteReference.removeValue()
		self.view?.endDetails()
	}

	fileprivate func convert(note: Note) -> DetailsViewModel {
		let formatter = DateFormatter.cached(withFormat: "MM/dd/yyyy")
		return DetailsViewModel(
				identifier: note.identifier,
				title: note.title,
				text: note.text,
				user: "",
				lastUpdated: formatter.string(from: note.updatedDate),
				created: formatter.string(from: note.createdDate)
		)
	}
}

struct DetailsViewModel {
	let identifier:  NoteIdentifier
	let title:       String
	let text:        String
	let user:        String
	let lastUpdated: String
	let created:     String
}
