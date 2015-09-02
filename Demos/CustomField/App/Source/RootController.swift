import UIKit
import Form.FORMViewController

class RootController: FORMViewController {
    init(JSON: [String : AnyObject], initialValues: [String : AnyObject]) {
        super.init(JSON: JSON, andInitialValues: initialValues, disabled:true)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(fromHex: "DAE2EA")
    }
}
