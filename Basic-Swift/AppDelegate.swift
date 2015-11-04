import UIKit
import Form.FORMDefaultStyle
import NSJSONSerialization_ANDYJSONFile
import Hex

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    if let JSON = NSJSONSerialization.JSONObjectWithContentsOfFile("forms.json") as? [String : AnyObject] {
      let initialValues = [
        "address"    : "Burger Park 667",
        "end_date"   : "2017-10-31 23:00:00 +00:00",
        "first_name" : "Ola",
        "last_name"  : "Nordman",
        "start_date" : "2014-10-31 23:00:00 +00:00"]
      let sampleController = SampleCollectionViewController(JSON: JSON, initialValues: initialValues)
      let rootViewController = UINavigationController(rootViewController: sampleController)

      rootViewController.view.tintColor = UIColor(hex: "5182AF")
      rootViewController.navigationBarHidden = true

      FORMDefaultStyle.applyStyle()

      self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
      self.window?.rootViewController = rootViewController
      self.window?.makeKeyAndVisible()
    }

    return true
  }

}

