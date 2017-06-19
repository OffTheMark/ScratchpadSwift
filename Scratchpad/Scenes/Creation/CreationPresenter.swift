import Foundation
import Firebase

class CreationPresenter {
	
	// MARK: Properties
	
	weak var view: CreationView?
	let notesReference:  DatabaseReference
	
	// MARK: CreationPresenter
	
	init(view: CreationView) {
		self.view = view
		self.notesReference = Database.database().reference(withPath: "notes")
	}
	
	func prepareView() {
		self.view?.display(viewModel: CreationViewModel())
	}
	
	func createNote(model: CreationViewModel) {
		let childReference = self.notesReference.childByAutoId()
		let note = Note(identifier: childReference.key, title: model.title, text: model.text)
		childReference.setValue(note.toDictionary())
		self.view?.endCreation()
	}
}

struct CreationViewModel {
	var title: String
	var text: String
	
	init(title: String = "", text: String = "") {
		self.title = title
		self.text = text
	}
}
