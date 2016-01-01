import UIKit
import Form.FORMBaseFieldCell

class SubtitleField: FORMBaseFieldCell {
    static let CellIdentifier = "SubtitleFieldIdentifier"

    lazy var textView: UITextView = {
        let horizontalMargin = 10.0
        let width = Double(self.frame.width) - horizontalMargin * 2.0
        let height = Double(self.frame.height)
        var frame = CGRect(x: horizontalMargin, y: 0, width: width, height: height)
        let view = UITextView(frame: frame)

        view.font = UIFont(name: "AvenirNext-Regular", size: 15.0)!
        view.textColor = UIColor.blackColor()

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.textView.text = "If you are an individual filling this petition, complete Item Number 1. If you are a company or an organization filling this petition, complete Item Number 2."

        self.addSubview(self.textView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
