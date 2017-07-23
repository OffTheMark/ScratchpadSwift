import Foundation

typealias FieldIdentifier = Int

struct ValidationError {
	let field:       FieldIdentifier
	let description: String
}
