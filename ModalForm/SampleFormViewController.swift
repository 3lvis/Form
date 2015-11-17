import Foundation
import UIKit
import Form
import NSJSONSerialization_ANDYJSONFile

class SampleFormViewController: FORMViewController {
    override internal var dataSource: FORMDataSource! {
        get {
            let layout = FORMLayout()
            self.collectionView?.collectionViewLayout = layout

            let JSON = NSJSONSerialization.JSONObjectWithContentsOfFile("Form.json")
            return FORMDataSource(JSON: JSON, collectionView: self.collectionView, layout: layout, values: nil, disabled: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}