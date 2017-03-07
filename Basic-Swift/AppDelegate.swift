import UIKit
import Form.FORMDefaultStyle
import NSJSONSerialization_ANDYJSONFile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        FORMDefaultStyle.apply()

        self.window?.rootViewController = UINavigationController(rootViewController: OptionsController())
        self.window?.makeKeyAndVisible()

        return true
    }
}
