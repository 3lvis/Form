import UIKit

class OptionsController: UITableViewController {
    enum OptionType: Int {
        case simple

        static var count: Int {
            return 1
        }

        var title: String {
            switch self {
            case .simple:
                return "Simple"

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
        case .simple:
            let controller = SimpleController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
