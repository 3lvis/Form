import UIKit
import Form.FORMBaseFieldCell

protocol BiographyFieldDelegate: class {
    func biographyFieldWasUpdated(text: String)
}

class BiographyField: FORMBaseFieldCell {
    static let CellIdentifier = "BiographyFieldIdentifier"

    weak var biographyFieldDelegate: BiographyFieldDelegate? = nil

    lazy var textView: UITextView = {
        let horizontalMargin = 10.0
        let width = Double(self.frame.width) - horizontalMargin * 2.0

        let topMargin = 30.0
        let height = Double(self.frame.height) - topMargin

        var frame = CGRect(x: horizontalMargin, y: topMargin, width: width, height: height)
        let view = UITextView(frame: frame)
        view.layer.borderColor = UIColor(hex: "35AEEE").CGColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5.0

        view.backgroundColor = UIColor(hex: "E0F5FF")
        view.font = UIFont(name: "AvenirNext-Regular", size: 15.0)!
        view.textColor = UIColor(hex: "455C73")
        view.delegate = self

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.headingLabel.text = "Biography"
        self.addSubview(self.textView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BiographyField: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.biographyFieldDelegate?.biographyFieldWasUpdated(textView.text)
    }
}