import Foundation
import Firebase

enum CreationFieldIdentifier: FieldIdentifier {
	case title
	case text
}

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
		self.view?.display(model: CreationViewModel())
	}
	
	func createNote(model: CreationViewModel) {
		let validationErrors = self.validate(model: model)
		
		if validationErrors.isEmpty {
			let childReference = self.notesReference.childByAutoId()
			let note = Note(identifier: childReference.key, title: model.title, text: model.text)
			childReference.setValue(note.toDictionary())
			self.view?.endCreation()
		}
		else {
			self.view?.display(errors: validationErrors)
		}
	}
	
	func validate(model: CreationViewModel) -> [ValidationError] {
		var errors = [ValidationError]()
		
		if model.title.isEmpty {
			errors.append(ValidationError(field: CreationFieldIdentifier.title.rawValue, description: "Title is required."))
		}
		
		return errors
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
