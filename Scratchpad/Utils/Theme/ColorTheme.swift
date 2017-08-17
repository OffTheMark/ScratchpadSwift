import Foundation
import UIKit

struct ColorTheme {
	// MARK:- Background

	static let primaryBackground = UIColor(red: 0.0 / 255.0, green: 95.0 / 255.0, blue: 154.0 / 255.0, alpha: 1)
	static let darkBackground    = UIColor(red: 84.0 / 255.0, green: 84.0 / 255.0, blue: 84.0 / 255.0, alpha: 1)
	static let lightBackground   = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
	static let whiteBackground   = UIColor.white

	// MARK:- Border
	
	static let mediumBorder = UIColor.lightGray
	
	// MARK:- Text

	static let blackText = UIColor.black
	static let darkText  = UIColor(red: 84.0 / 255.0, green: 84.0 / 255.0, blue: 84.0 / 255.0, alpha: 1)
	static let lightText = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
	static let whiteText = UIColor.white
	static let errorText = UIColor.red
}
