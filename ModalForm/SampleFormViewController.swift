import UIKit
import Form
import NSJSONSerialization_ANDYJSONFile

class SampleFormViewController: FORMViewController {
    init() {
        let JSON = JSONSerialization.jsonObject(withContentsOfFile: "Form.json")
        super.init(json: JSON, andInitialValues: nil, disabled:false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.gray
        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}
