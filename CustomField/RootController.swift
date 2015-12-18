import UIKit
import Form.FORMViewController

class RootController: FORMViewController {
    init(JSON: [String : AnyObject], initialValues: [String : AnyObject]) {
        super.init(JSON: JSON, andInitialValues: initialValues, disabled:false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(hex: "DAE2EA")
        self.collectionView?.registerClass(BiographyField.self, forCellWithReuseIdentifier: BiographyField.CellIdentifier)

        let configureCellForItemAtIndexPathBlock: FORMConfigureCellForItemAtIndexPathBlock = { field, collectionView, indexPath in
            if field.type == .Custom && field.typeString == "biography" {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(BiographyField.CellIdentifier, forIndexPath: indexPath) as! BiographyField
                cell.biographyFieldDelegate = self
                return cell
            }

            return nil
        }

        self.dataSource.configureCellForItemAtIndexPathBlock = configureCellForItemAtIndexPathBlock
    }
}

extension RootController: BiographyFieldDelegate {
    func biographyFieldWasUpdated(text: String) {
        print(text)
    }
}
