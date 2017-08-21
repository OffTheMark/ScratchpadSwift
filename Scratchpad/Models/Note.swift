import Foundation

typealias NoteIdentifier = String

struct Note {
	let identifier:  NoteIdentifier
	let owner:		 UserIdentifier
	let title:       String
	let text:        String
	let updatedDate: Date
	let createdDate: Date

	init(identifier: NoteIdentifier, owner: UserIdentifier, title: String, text: String, updatedAt: Date, createdAt: Date) {
		self.identifier = identifier
		self.owner = owner
		self.title = title
		self.text = text
		self.updatedDate = updatedAt
		self.createdDate = createdAt
	}

	init(identifier: NoteIdentifier, owner: UserIdentifier, title: String, text: String) {
		let currentDate = Date()
		self.init(identifier: identifier, owner: owner, title: title, text: text, updatedAt: currentDate, createdAt: currentDate)
	}

	static func make(from dictionary: [String:Any]) -> Note {
		let identifier       = dictionary["identifier"] as! NoteIdentifier
		let owner			 = dictionary["owner"] as! UserIdentifier
		let title            = dictionary["title"] as! String
		let text             = dictionary["text"] as! String
		let updatedTimestamp = dictionary["updatedAt"] as! TimeInterval
		let createdTimestamp = dictionary["createdAt"] as! TimeInterval
		return Note(
				identifier: identifier,
				owner: owner,
				title: title,
				text: text,
				updatedAt: Date(timeIntervalSince1970: updatedTimestamp),
				createdAt: Date(timeIntervalSince1970: createdTimestamp)
		)
	}

	func toDictionary() -> [String:Any] {
		return [
				"identifier": self.identifier,
				"owner": self.owner,
				"title": self.title,
				"text": self.text,
				"updatedAt": self.updatedDate.timeIntervalSince1970,
				"createdAt": self.createdDate.timeIntervalSince1970
		]
	}
}
