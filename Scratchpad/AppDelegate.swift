import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		
		UINavigationBar.appearance().barTintColor = ColorTheme.primaryBackground
		UINavigationBar.appearance().tintColor = ColorTheme.whiteText
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : ColorTheme.whiteText]
		
		UIToolbar.appearance().tintColor = ColorTheme.primaryBackground
		
		return true
	}
}

