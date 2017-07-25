import Foundation
import Firebase

class ListingPresenter {

	// MARK: Properties

	private weak var view: ListingView?
	private let notesReference:  DatabaseReference
	private var referenceHandle: UInt?

	// MARK: ListingPresenter

	init(view: ListingView) {
		self.view = view
		self.notesReference = Database.database()
									  .reference(withPath: "notes")
		self.referenceHandle = self.notesReference
				.observe(.value, with: {
					snapshot in
					var notes = [Note]()

					for item in snapshot.children {
						let itemSnapshot = item as! DataSnapshot
						let itemValue    = itemSnapshot.value as! [String:Any]
						let note         = Note.make(from: itemValue)
						notes.append(note)
					}
					
					notes.sort {
						(leftNote, rightNote) -> Bool in
						return leftNote.updatedDate > rightNote.updatedDate
					}
					
					self.view?.update(with: self.convert(notes: notes))
				})
	}

	deinit {
		if let handle = self.referenceHandle {
			self.notesReference.removeObserver(withHandle: handle)
		}
	}

	internal func convert(notes: [Note]) -> [ListingViewModel] {
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
