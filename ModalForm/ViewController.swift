import UIKit
import Form

class ViewController: UIViewController {
    @IBAction func showForm(sender: UIButton) {
        let formController = SampleFormViewController()
        self.presentViewController(formController, animated: true, completion: nil)
    }
}

