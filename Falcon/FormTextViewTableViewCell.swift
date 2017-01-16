//
//  FormTextViewTableViewCell.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-17.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormTextViewTableViewCell: UITableViewCell {

    @IBOutlet open weak var textView: UITextView!
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    public var formTextView: FormTextView! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        textView.text = formTextView.text
        textView.autocapitalizationType = formTextView.autoCapitalizationType
        textView.autocorrectionType = formTextView.autoCorrectionType
        textView.keyboardType = formTextView.keyboardType
        
        selectionStyle = .none
        
        //frame.size = CGSize(width: frame.size.width, height: CGFloat(formTextView!.height))
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FormTextViewTableViewCell.dismissKeyboard))
        toolBar.items = [flexibleSpace, barButton]
    
        textView.inputAccessoryView = toolBar;
        
        heightConstraint.constant = CGFloat(formTextView.height)
    }
    
    func dismissKeyboard() {
        textView.resignFirstResponder()
    }
}

extension FormTextViewTableViewCell: UITextFieldDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        formTextView.text = textView.text
        
        if let changeBlock = formTextView.changeBlock {
            changeBlock(textView.text)
        }
    }
}
