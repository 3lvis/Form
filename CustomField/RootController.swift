import UIKit
import Form.FORMViewController

class RootController: FORMViewController {
    init(JSON: [String: AnyObject], initialValues: [String: AnyObject]) {
        super.init(json: JSON, andInitialValues: initialValues, disabled: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(hex: "DAE2EA")
        self.collectionView?.register(BiographyField.self, forCellWithReuseIdentifier: BiographyField.CellIdentifier)
        self.collectionView?.register(SubtitleField.self, forCellWithReuseIdentifier: SubtitleField.CellIdentifier)

        let configureCellForItemAtIndexPathBlock: FORMConfigureCellForItemAtIndexPathBlock = { field, collectionView, indexPath in
            if field!.type == .custom && field!.typeString == "biography" {
                let cell = collectionView!.dequeueReusableCell(withReuseIdentifier: BiographyField.CellIdentifier, for: indexPath!) as! BiographyField
                cell.biographyFieldDelegate = self
                return cell
            } else if field!.type == .custom && field!.typeString == "subtitle" {
                let cell = collectionView!.dequeueReusableCell(withReuseIdentifier: SubtitleField.CellIdentifier, for: indexPath!) as! SubtitleField
                return cell
            }

            return nil
        }

        self.dataSource.configureCellForItemAtIndexPathBlock = configureCellForItemAtIndexPathBlock
    }
}

extension RootController: BiographyFieldDelegate {
    func biographyFieldWasUpdated(_ text: String) {
        print(text)
    }
}
