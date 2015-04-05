import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FORMDefaultStyle.applyStyle()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let initialValues: Dictionary<NSObject, AnyObject> = [
            "address"    : "Burger Park 667",
            "end_date"   : "2017-10-31 23:00:00 +00:00",
            "first_name" : "Ola",
            "last_name"  : "Nordman",
            "start_date" : "2014-10-31 23:00:00 +00:00"]
        var JSON: AnyObject? = NSJSONSerialization.JSONObjectWithContentsOfFile("forms.json")

        if (JSON != nil) {
            let sampleController = SampleCollectionViewController(initialValues: initialValues, JSON: JSON)
            let rootViewController = UINavigationController(rootViewController: sampleController)

            rootViewController.view.tintColor = UIColor(fromHex: "5182AF")
            rootViewController.navigationBarHidden = true

            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
        }

        return true
    }

}

