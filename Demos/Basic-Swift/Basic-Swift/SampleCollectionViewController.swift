import UIKit

class SampleCollectionViewController: UICollectionViewController {

  var formDataSource: FORMDataSource?
  var layout: FORMLayout

  var initialValues :Dictionary<NSObject, AnyObject>?
  var JSON: AnyObject?

  init(initialValues: Dictionary<NSObject, AnyObject>, JSON: AnyObject?) {
    self.initialValues = initialValues
    self.JSON = JSON
    self.layout = FORMLayout()

    super.init(collectionViewLayout: self.layout)
  }

  required init(coder aDecoder: NSCoder) {
    self.layout = FORMLayout()

    super.init(coder: aDecoder)
  }

  // MARK: Getters

  func dataSource() -> FORMDataSource {
    if self.formDataSource == nil {
      self.formDataSource = FORMDataSource(JSON: self.JSON,
        collectionView: self.collectionView,
        layout: self.layout,
        values: self.initialValues,
        disabled: true)
    }

    return self.formDataSource!
  }

  // MARK: View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.edgesForExtendedLayout = .None
    self.collectionView?.backgroundColor = UIColor(fromHex: "DAE2EA")
    self.collectionView?.dataSource = self.dataSource()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    let validateButtonItem = UIBarButtonItem(title: "Validate",
      style: .Done,
      target: self,
      action: NSSelectorFromString("validateButtonAction"))

    let updateButtonItem = UIBarButtonItem(title: "Update",
      style: .Done,
      target: self,
      action: NSSelectorFromString("updateButtonAction"))

    let flexibleBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
      target: nil,
      action: nil)

    let readOnlyView = UIView(frame: CGRectMake(0.0, 0.0, 150.0, 40.0))
    let readOnlyLabel = UILabel(frame: CGRectMake(0.0, 0.0, 90.0, 40.0))
    readOnlyLabel.text = "Read-Only"
    readOnlyLabel.textColor = UIColor(fromHex: "5182AF")
    readOnlyLabel.font = UIFont.boldSystemFontOfSize(17.0)

    readOnlyView.addSubview(readOnlyLabel)

    let readOnlySwitch = UISwitch(frame: CGRectMake(90.0, 5.0, 40.0, 40.0))
    readOnlySwitch.tintColor = UIColor(fromHex: "5182AF")
    readOnlySwitch.on = true
    readOnlySwitch.addTarget(self,
      action: NSSelectorFromString("readOnly:"),
      forControlEvents: .ValueChanged)

    readOnlyView.addSubview(readOnlySwitch)

    let readOnlyBarButtonItem = UIBarButtonItem(customView: readOnlyView)

    self.setToolbarItems([validateButtonItem, flexibleBarButtonItem, updateButtonItem, flexibleBarButtonItem, readOnlyBarButtonItem], animated: false)

    self.navigationController?.setToolbarHidden(false, animated: true)
  }

  // MARK: Actions

  func readOnly(sender: UISwitch) {
    if sender.on {
      self.dataSource().disable()
    } else {
      self.dataSource().enable()
    }
  }

  func validateButtonAction() {
    if self.dataSource().isValid() {
      UIAlertView(title: "Everything is valid, you get a 🍬!",
        message: nil,
        delegate: nil,
        cancelButtonTitle: "No thanks!").show()
    } else {
      self.dataSource().validate()
    }
  }

  func updateButtonAction() {
    self.dataSource().reloadWithDictionary(["first_name" : "Hodo",
      "salary_type" : 1,
      "hourly_pay_level" : 1,
      "hourly_pay_premium_percent" : 10,
      "hourly_pay_premium_currency" : 10,
      "start_date" : NSNull(),
      "username": 1
      ])
    self.collectionView?.reloadData()
  }

  // MARK: UICollectionViewDelegate

  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
    return self.dataSource().sizeForFieldAtIndexPath(indexPath)
  }

}

