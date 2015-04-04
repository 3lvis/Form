import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let initialValues: Dictionary<NSObject, AnyObject> = ["address" : "Burger Park 667"]
        var JSON: AnyObject? = self.getJSON("forms.json")

        if (JSON != nil) {
            let sampleController = SampleCollectionViewController(initialValues: initialValues, JSON: JSON)
            let controller = UINavigationController(rootViewController: sampleController)

            controller.view.tintColor = UIColor(fromHex: "5182AF")
            controller.navigationBarHidden = true

            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }

        return true
    }

    func getJSON(fileName: String) -> AnyObject? {
        let bundle = NSBundle.mainBundle()
        let filePath: String? = bundle.pathForResource(fileName.stringByDeletingPathExtension,
            ofType: fileName.pathExtension)
        let data: NSData? = NSData(contentsOfFile: filePath!)
        var error: NSError?

        let result: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &error)

        if (error == nil) {
            return result
        } else {
            return nil
        }
    }

}

