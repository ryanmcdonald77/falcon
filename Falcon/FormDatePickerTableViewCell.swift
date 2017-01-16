//
//  FormDatePickerTableViewCell.swift
//  Falcon
//
//  Created by Tayson Nguyen on 2016-07-22.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormDatePickerTableViewCell: UITableViewCell {

    @IBOutlet open weak var datePicker: UIDatePicker!
    
    public var formDatePicker: FormDatePicker! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        datePicker.minuteInterval = formDatePicker.minuteInterval
        datePicker.date = formDatePicker.date
    }
    
    @IBAction func dateChanged() {
        formDatePicker.date = datePicker.date
        if let changeBlock = formDatePicker.changeBlock {
            changeBlock(datePicker.date)
        }
    }
    
}
