import UIKit
import Form
import NSJSONSerialization_ANDYJSONFile
import Hex

@UIApplicationMain
class AppController: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if let JSON = NSJSONSerialization.JSONObjectWithContentsOfFile("forms.json") as? [[String : AnyObject]] {
            FORMCustomStyle.applyStyle()
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = RootController(JSON: JSON)
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
}

