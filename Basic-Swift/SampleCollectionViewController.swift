import UIKit
import Form.FORMViewController

class SampleCollectionViewController: FORMViewController {

    init(JSON: [String : AnyObject], initialValues: [String : AnyObject]) {
        super.init(json: JSON, andInitialValues: initialValues, disabled:true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(hex: "DAE2EA")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let validateButtonItem = UIBarButtonItem(title: "Validate",
            style: .done,
            target: self,
            action: NSSelectorFromString("validateButtonAction"))

        let updateButtonItem = UIBarButtonItem(title: "Update",
            style: .done,
            target: self,
            action: NSSelectorFromString("updateButtonAction"))

        let flexibleBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)

        let readOnlyView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 40.0))
        let readOnlyLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 90.0, height: 40.0))
        readOnlyLabel.text = "Read-Only"
        readOnlyLabel.textColor = UIColor(hex: "5182AF")
        readOnlyLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        readOnlyView.addSubview(readOnlyLabel)

        let readOnlySwitch = UISwitch(frame: CGRect(x: 90.0, y: 5.0, width: 40.0, height: 40.0))
        readOnlySwitch.tintColor = UIColor(hex: "5182AF")
        readOnlySwitch.isOn = true
        readOnlySwitch.addTarget(self,
            action: NSSelectorFromString("readOnly:"),
            for: .valueChanged)

        readOnlyView.addSubview(readOnlySwitch)

        let readOnlyBarButtonItem = UIBarButtonItem(customView: readOnlyView)

        self.setToolbarItems([validateButtonItem, flexibleBarButtonItem, updateButtonItem, flexibleBarButtonItem, readOnlyBarButtonItem], animated: false)

        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    // MARK: Actions

    func readOnly(_ sender: UISwitch) {
        if sender.isOn {
            self.dataSource.disable()
        } else {
            self.dataSource.enable()
        }
    }

    func validateButtonAction() {
        if self.dataSource.isValid {
            UIAlertView(title: "Everything is valid, you get a 🍬!",
                message: nil,
                delegate: nil,
                cancelButtonTitle: "No thanks!").show()
        } else {
            self.dataSource.validate()
        }
    }
    
    func updateButtonAction() {
        self.dataSource.reload(with: ["first_name" : "Hodo",
            "salary_type" : 1,
            "hourly_pay_level" : 1,
            "hourly_pay_premium_percent" : 10,
            "hourly_pay_premium_currency" : 10,
            "start_date" : NSNull(),
            "username": 1
            ])
        
        self.collectionView?.reloadData()
    }
}

