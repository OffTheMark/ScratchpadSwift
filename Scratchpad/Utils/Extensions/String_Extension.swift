import Foundation

extension String {
	var isEmail: Bool {
		let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
		return predicate.evaluate(with: self)
	}
}
