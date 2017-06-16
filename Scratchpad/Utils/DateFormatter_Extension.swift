import Foundation

private var cachedFormatters = [String : DateFormatter]()

extension DateFormatter {
	
	static func cached(withFormat format: String) -> DateFormatter {
		if let cachedFormatter = cachedFormatters[format] {
			return cachedFormatter
		}
		let formatter = DateFormatter()
		formatter.dateFormat = format
		cachedFormatters[format] = formatter
		return formatter
	}
	
}
