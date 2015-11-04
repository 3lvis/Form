import UIKit
import Form.FORMViewController

class RootController: FORMViewController {
    init(JSON: [[String : AnyObject]]) {
        super.init(JSON: JSON, andInitialValues: nil, disabled:false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(hex: "122556")

        let fieldUpdatedBlock: FORMFieldFieldUpdatedBlock =  { cell, field in
            if field.fieldID == "pay_button" {
                if self.dataSource.valid == false {
                    self.dataSource.validate()
                } else {
                    print("Successfull values, process shopping cart!")
                }
            }
        }

        self.dataSource.fieldUpdatedBlock = fieldUpdatedBlock
    }

    // MARK: CustomFieldDelegate

    func customFieldWasUpdated(text: String) {
        print(text)
    }
}
