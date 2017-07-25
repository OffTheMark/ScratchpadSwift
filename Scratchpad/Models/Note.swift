import Foundation

typealias NoteIdentifier = String

struct Note {
	let identifier:  NoteIdentifier
	let title:       String
	let text:        String
	let updatedDate: Date
	let createdDate: Date

	init(identifier: String, title: String, text: String, updatedAt: Date, createdAt: Date) {
		self.identifier = identifier
		self.title = title
		self.text = text
		self.updatedDate = updatedAt
		self.createdDate = createdAt
	}

	init(identifier: String, title: String, text: String) {
		let currentDate = Date()
		self.init(identifier: identifier, title: title, text: text, updatedAt: currentDate, createdAt: currentDate)
	}

	static func make(from dictionary: [String:Any]) -> Note {
		let identifier       = dictionary["identifier"] as! String
		let title            = dictionary["title"] as! String
		let text             = dictionary["text"] as! String
		let updatedTimestamp = dictionary["updatedAt"] as! TimeInterval
		let createdTimestamp = dictionary["createdAt"] as! TimeInterval
		return Note(
				identifier: identifier,
				title: title,
				text: text,
				updatedAt: Date(timeIntervalSince1970: updatedTimestamp),
				createdAt: Date(timeIntervalSince1970: createdTimestamp)
		)
	}

	func toDictionary() -> [String:Any] {
		return [
				"identifier": self.identifier,
				"title": self.title,
				"text": self.text,
				"updatedAt": self.updatedDate.timeIntervalSince1970,
				"createdAt": self.createdDate.timeIntervalSince1970
		]
	}
}
