extension FORMTextFieldCell {
    public override func updateWithField(field: FORMField!) {
        super.updateWithField(field)

        self.textField.hidden = field.sectionSeparator
        self.textField.inputType = self.inputType(field.inputTypeString)
        self.textField.enabled = !field.disabled
        self.textField.valid = field.valid
        self.textField.text = self.rawTextForField(field)
    }

    func inputType(inputTypeString: String) -> FormTextFieldInputType {
        var inputType: FormTextFieldInputType

        if inputTypeString == "name" {
            inputType = .Name
        } else if inputTypeString == "username" {
            inputType = .Username
        } else if inputTypeString == "phone" || inputTypeString == "phone_number" {
            inputType = .PhoneNumber
        } else if inputTypeString == "number" || inputTypeString == "integer" {
            inputType = .Integer
        } else if inputTypeString == "float" || inputTypeString == "decimal" {
            inputType = .Decimal
        } else if inputTypeString == "address" {
            inputType = .Address
        } else if inputTypeString == "email" {
            inputType = .Email
        } else if inputTypeString == "text" {
            inputType = .Default
        } else if inputTypeString == "password" {
            inputType = .Password
        } else if inputTypeString == "count" {
            inputType = .Default
        } else if inputTypeString.characters.count == 0 {
            inputType = .Default
        } else {
            inputType = .Unknown
        }

        return inputType
    }
}

extension FORMTextFieldCell: FormTextFieldDelegate {
    public func formTextFieldDidBeginEditing(textField: FormTextField) {
        self.performSelector("showTooltip", withObject: nil, afterDelay: 0.1)
    }

    public func formTextFieldDidEndEditing(textField: FormTextField) {
        self.validate()

        if (!self.textField.valid) {
            self.textField.valid = self.field.validate()
        }

        if self.showTooltips {
            NSNotificationCenter.defaultCenter().postNotificationName(FORMDismissTooltipNotification, object: nil)
        }
    }

    public func formTextField(textField: FormTextField, didUpdateWithText text: String?) {
        self.field.value = text
        self.validate()

        if !self.textField.valid {
            self.textField.valid = self.field.validate()
        }

        if let delegate = self.delegate {
            if delegate.respondsToSelector("fieldCell:updatedWithField:") {
                self.delegate?.fieldCell(self, updatedWithField: self.field)
            }
        }
    }

    public func formTextFieldDidReturn(textField: FormTextField) {

    }
}