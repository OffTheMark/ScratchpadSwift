import Foundation

struct Note {
	let identifier: String
	let title:      String
	let text:       String
	let updatedAt:  Date
	let createdAt:  Date
	
	init(identifier: String, title: String, text: String, updatedAt: Date, createdAt: Date) {
		self.identifier = identifier
		self.title = title
		self.text = text
		self.updatedAt = updatedAt
		self.createdAt = createdAt
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
			"updatedAt": self.updatedAt.timeIntervalSince1970,
			"createdAt": self.createdAt.timeIntervalSince1970
		]
	}
}
