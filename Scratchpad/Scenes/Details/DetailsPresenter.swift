import Foundation
import Firebase

class DetailsPresenter {

	// MARK: Properties

	weak private var view: DetailsView?
	private let identifier: String
	private let database: Database
	private let authentication: Auth
	private var referenceHandles: Set<UInt> = []

	// MARK: DetailsPresenter

	init(view: DetailsView, for identifier: String, database: Database = Database.database(), authentication: Auth = Auth.auth()) {
		self.view = view
		self.database = database
		self.authentication = authentication
		self.identifier = identifier
	}
	
	func prepareView() {
		let referenceHandle = self.database
			.reference(withPath: "notes")
			.child(self.identifier)
			.observe(.value, with: {
				snapshot in
				if let value = snapshot.value as? [String:Any] {
					let note = Note.make(from: value)
					
					guard let userIdentifier = self.authentication.currentUser?.uid,
						note.owner != userIdentifier else {
							self.view?.endDetailsAccessDenied()
							return
					}
					
					self.view?.update(viewModel: self.convert(note: note))
				}
			})
		self.referenceHandles.insert(referenceHandle)
	}

	deinit {
		for handle in self.referenceHandles {
			self.database
				.reference(withPath: "notes")
				.child(self.identifier)
				.removeObserver(withHandle: handle)
		}
	}

	func deleteNote() {
		self.database
			.reference(withPath: "notes")
			.child(self.identifier)
			.removeValue()
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
