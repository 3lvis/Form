import UIKit
import Form.FORMDefaultStyle
import NSJSONSerialization_ANDYJSONFile
import Hex

@UIApplicationMain
class AppController: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let JSON = JSONSerialization.jsonObject(withContentsOfFile: "forms.json") as? [[String : AnyObject]] {
            FORMCustomStyle.apply()
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = RootController(JSON: JSON)
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
}

