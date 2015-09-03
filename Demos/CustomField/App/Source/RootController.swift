import UIKit
import Form.FORMViewController

class RootController: FORMViewController, CustomFieldDelegate {
    init(JSON: [String : AnyObject], initialValues: [String : AnyObject]) {
        super.init(JSON: JSON, andInitialValues: initialValues, disabled:false)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(fromHex: "DAE2EA")

        self.collectionView?.registerClass(CustomField.self, forCellWithReuseIdentifier: CustomField.CellIdentifier)

        let configureCellForItemAtIndexPathBlock: FORMConfigureCellForItemAtIndexPathBlock = { field, collectionView, indexPath in
            if field.type == .Custom && field.typeString == "textye" {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CustomField.CellIdentifier, forIndexPath: indexPath) as! CustomField
                cell.customDelegate = self
                return cell
            }

            return nil
        }

        self.dataSource.configureCellForItemAtIndexPathBlock = configureCellForItemAtIndexPathBlock
    }

    // MARK: CustomFieldDelegate

    func customFieldWasUpdated(text: String) {
        println(text)
    }
}
