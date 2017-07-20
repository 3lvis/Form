import UIKit
import Form

class ViewController: UIViewController {
    @IBAction func showForm(_: UIButton) {
        let formController = SampleFormViewController()

        if UIDevice.current.userInterfaceIdiom == .pad {
            formController.modalPresentationStyle = .formSheet
        }

        self.present(formController, animated: true, completion: nil)
    }
}
