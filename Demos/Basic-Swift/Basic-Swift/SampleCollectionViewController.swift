import UIKit

class SampleCollectionViewController: UICollectionViewController {

    var dataSource: FORMDataSource? {
        return FORMDataSource(JSON: self.JSON,
            collectionView: self.collectionView,
            layout: self.layout,
            values: self.initialValues,
            disabled: true)
    }

    var layout: FORMLayout {
        return FORMLayout()
    }

    var initialValues :Dictionary<NSObject, AnyObject>?
    var JSON: AnyObject?

    override init() {
        super.init()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

