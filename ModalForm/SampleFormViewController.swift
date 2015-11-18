import Foundation
import UIKit
import Form
import NSJSONSerialization_ANDYJSONFile

class SampleFormViewController: FORMViewController {
    override func viewDidLoad() {
        self.JSON = NSJSONSerialization.JSONObjectWithContentsOfFile("Form.json")
        self.initialValues = [NSObject : AnyObject]()
        self.disabled = false

        super.viewDidLoad()

        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}