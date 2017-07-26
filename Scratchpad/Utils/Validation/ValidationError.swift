import Foundation

typealias FieldIdentifier = Int

struct ValidationError: Equatable {
	let field:       FieldIdentifier
	let description: String
}

func ==(left: ValidationError, right: ValidationError) -> Bool {
	return left.field.hashValue == right.field.hashValue &&
		left.description.hashValue == right.description.hashValue
}
