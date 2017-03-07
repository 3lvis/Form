import UIKit

class OptionsController: UITableViewController {
    enum OptionType: Int {
        case simpleField
        case calculatedField
        case customValidator

        static var count: Int {
            return 3
        }

        var title: String {
            switch self {
            case .simpleField: return "Simple field"
            case .calculatedField: return "Calculated field"
            case .customValidator: return "Custom validator"
            }
        }
    }

    var cellIdentifier: String {
        return String(describing: UITableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OptionType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)

        let type = OptionType(rawValue: indexPath.row)!
        cell.textLabel?.text = type.title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = OptionType(rawValue: indexPath.row)!

        switch type {
        case .simpleField:
            let controller = LoadedFromJSONFileController(fileName: "simple-field.json")
            self.navigationController?.pushViewController(controller, animated: true)
        case .calculatedField:
            let controller = LoadedFromJSONFileController(fileName: "calculated-field.json")
            self.navigationController?.pushViewController(controller, animated: true)
        case .customValidator:
            let controller = LoadedFromJSONFileController(fileName: "custom-validator.json")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
