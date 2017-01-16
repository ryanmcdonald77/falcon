//
//  FormTextFieldTableViewCell.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-13.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormTextFieldTableViewCell: UITableViewCell {

    @IBOutlet open weak var label: UILabel!
    @IBOutlet open weak var textField: UITextField!
    
    public var formTextField: FormTextField! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        label.text = formTextField.title
        
        if formTextField.title == nil {
            label.isHidden = true
            textField.textAlignment = .left
        } else {
            label.isHidden = false
            textField.textAlignment = .right
        }

        textField.placeholder = formTextField.placeHolder
        textField.text = formTextField.text
        textField.autocapitalizationType = formTextField.autoCapitalizationType
        textField.autocorrectionType = formTextField.autoCorrectionType
        textField.isSecureTextEntry = formTextField.isSecureTextEntry
        textField.keyboardType = formTextField.keyboardType
        textField.enablesReturnKeyAutomatically = true
        selectionStyle = .none
    }
    
    @IBAction func textFieldChanged(_ sender: AnyObject) {
        formTextField.text = textField.text
        
        if let changeBlock = formTextField.changeBlock {
            changeBlock(textField.text!)
        }
        
    }
}

extension FormTextFieldTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false;
    }
}
