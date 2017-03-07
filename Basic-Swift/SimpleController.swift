import UIKit
import Form.FORMViewController

class SimpleController: FORMViewController {

    init() {
        let JSON = JSONSerialization.jsonObject(withContentsOfFile: "forms.json") as! [String: AnyObject]

        super.init(json: JSON, andInitialValues: [String: AnyObject](), disabled: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.collectionView?.backgroundColor = UIColor(hex: "DAE2EA")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Values", style: .done, target: self, action: #selector(printValues))
    }

    func printValues() {
        print(self.dataSource.values)
    }
}
