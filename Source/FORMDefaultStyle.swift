import UIKit
import Hex
import FormTextField

public class FORMDefaultStyle: NSObject {
    public class func applyStyle() {
        FORMBaseFieldCell.appearance().setHeadingLabelFont(UIFont(name: "AvenirNext-DemiBold", size: 14.0))
        FORMBaseFieldCell.appearance().setHeadingLabelTextColor(UIColor(hex: "28649C"))

        FORMBackgroundView.appearance().backgroundColor = UIColor(hex: "DAE2EA")
        FORMBackgroundView.appearance().setGroupBackgroundColor(UIColor(hex: "DAE2EA"))

        FORMSeparatorView.appearance().setSeparatorColor(UIColor(hex: "C6C6C6"))

        FORMButtonFieldCell.appearance().setBackgroundColor(UIColor(hex: "3DAFEB"))
        FORMButtonFieldCell.appearance().setTitleLabelFont(UIFont(name: "AvenirNext-DemiBold", size: 16))
        FORMButtonFieldCell.appearance().setBorderWidth(1)
        FORMButtonFieldCell.appearance().setCornerRadius(5)
        FORMButtonFieldCell.appearance().setHighlightedTitleColor(UIColor(hex: "3DAFEB"))
        FORMButtonFieldCell.appearance().setBorderColor(UIColor(hex: "3DAFEB"))
        FORMButtonFieldCell.appearance().setHighlightedBackgroundColor(UIColor.whiteColor())
        FORMButtonFieldCell.appearance().setTitleColor(UIColor.whiteColor())

        FORMFieldValueCell.appearance().setTextLabelFont(UIFont(name: "AvenirNext-Medium", size: 17))
        FORMFieldValueCell.appearance().setTextLabelColor(UIColor(hex: "455C73"))
        FORMFieldValueCell.appearance().setDetailTextLabelHighlightedTextColor(UIColor.whiteColor())
        FORMFieldValueCell.appearance().setDetailTextLabelFont(UIFont(name: "AvenirNext-Regular", size: 14))
        FORMFieldValueCell.appearance().setDetailTextLabelColor(UIColor(hex: "455C73"))
        FORMFieldValueCell.appearance().setDetailTextLabelHighlightedTextColor(UIColor.whiteColor())
        FORMFieldValueCell.appearance().setSelectedBackgroundViewColor(UIColor(hex: "008ED9"))
        FORMFieldValueCell.appearance().setSelectedBackgroundFontColor(UIColor.whiteColor())

        let enabledBackgroundColor = UIColor(hex: "E1F5FF")
        let enabledBorderColor = UIColor(hex: "3DAFEB")
        let enabledTextColor = UIColor(hex: "455C73")
        let activeBorderColor = UIColor(hex: "3DAFEB")

        FormTextField.appearance().borderWidth = 1
        FormTextField.appearance().cornerRadius = 5
        FormTextField.appearance().accessoryButtonColor = activeBorderColor
        FormTextField.appearance().font = UIFont(name: "AvenirNext-Regular", size: 15)

        FormTextField.appearance().enabledBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().enabledBorderColor = enabledBorderColor
        FormTextField.appearance().enabledTextColor = enabledTextColor

        FormTextField.appearance().validBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().validBorderColor = enabledBorderColor
        FormTextField.appearance().validTextColor = enabledTextColor

        FormTextField.appearance().activeBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().activeBorderColor = activeBorderColor
        FormTextField.appearance().activeTextColor = enabledTextColor

        FormTextField.appearance().inactiveBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().inactiveBorderColor = enabledBorderColor
        FormTextField.appearance().inactiveTextColor = enabledTextColor

        FormTextField.appearance().disabledBackgroundColor = UIColor(hex: "F5F5F8")
        FormTextField.appearance().disabledBorderColor = UIColor(hex: "DEDEDE")
        FormTextField.appearance().disabledTextColor = UIColor.whiteColor()

        FormTextField.appearance().invalidBackgroundColor = UIColor(hex: "FFD7D7")
        FormTextField.appearance().invalidBorderColor = UIColor(hex: "EC3031")
        FormTextField.appearance().invalidTextColor = UIColor(hex: "EC3031")

        FORMFieldValueLabel.appearance().setCustomFont(UIFont(name: "AvenirNext-Regular", size: 15.0))
        FORMFieldValueLabel.appearance().textColor = UIColor(hex: "455C73")
        FORMFieldValueLabel.appearance().setBorderWidth(1)
        FORMFieldValueLabel.appearance().setBorderColor(UIColor(hex: "3DAFEB"))
        FORMFieldValueLabel.appearance().setCornerRadius(5)
        FORMFieldValueLabel.appearance().setActiveBackgroundColor(UIColor(hex: "C0EAFF"))
        FORMFieldValueLabel.appearance().setActiveBorderColor(UIColor(hex: "3DAFEB"))
        FORMFieldValueLabel.appearance().setInactiveBackgroundColor(UIColor(hex: "E1F5FF"))
        FORMFieldValueLabel.appearance().setInactiveBorderColor(UIColor(hex: "3DAFEB"))
        FORMFieldValueLabel.appearance().setEnabledBackgroundColor(UIColor(hex: "E1F5FF"))
        FORMFieldValueLabel.appearance().setEnabledBorderColor(UIColor(hex: "3DAFEB"))
        FORMFieldValueLabel.appearance().setEnabledTextColor(UIColor(hex: "455C73"))
        FORMFieldValueLabel.appearance().setDisabledBackgroundColor(UIColor(hex: "F5F5F8"))
        FORMFieldValueLabel.appearance().setDisabledBorderColor(UIColor(hex: "DEDEDE"))
        FORMFieldValueLabel.appearance().setDisabledTextColor(UIColor.grayColor())
        FORMFieldValueLabel.appearance().setValidBackgroundColor(UIColor(hex: "E1F5FF"))
        FORMFieldValueLabel.appearance().setValidBorderColor(UIColor(hex: "3DAFEB"))
        FORMFieldValueLabel.appearance().setInvalidBackgroundColor(UIColor(hex: "FFD7D7"))
        FORMFieldValueLabel.appearance().setInvalidBorderColor(UIColor(hex: "EC3031"))

        FORMGroupHeaderView.appearance().setHeaderLabelFont(UIFont(name: "AvenirNext-Medium", size: 17))
        FORMGroupHeaderView.appearance().setHeaderLabelTextColor(UIColor(hex: "455C73"))
        FORMGroupHeaderView.appearance().setHeaderBackgroundColor(UIColor.whiteColor())

        FORMFieldValuesTableViewHeader.appearance().setInfoLabelFont(UIFont(name: "AvenirNext-UltraLight", size: 17))
        FORMFieldValuesTableViewHeader.appearance().setInfoLabelTextColor(UIColor(hex: ""))

        FORMTextFieldCell.appearance().setTooltipLabelFont(UIFont(name: "AvenirNext-Medium", size: 14))
        FORMTextFieldCell.appearance().setTooltipLabelTextColor(UIColor(hex: "97591D"))
        FORMTextFieldCell.appearance().setTooltipBackgroundColor(UIColor(hex: "FDFD54"))
    }
}