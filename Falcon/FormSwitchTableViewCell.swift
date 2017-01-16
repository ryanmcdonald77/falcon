//
//  FormSwitchTableViewCell.swift
//  Habit
//
//  Created by Tayson on 2015-09-16.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormSwitchTableViewCell: UITableViewCell {

    @IBOutlet open weak var label: UILabel!
    @IBOutlet open weak var switchControl: UISwitch!
    
    public var formSwitch: FormSwitch! {
        didSet {
            setupView()
        }
    }

    func setupView() {
        label.text = formSwitch.title
        switchControl.isOn = formSwitch.on
        selectionStyle = .none
    }
    
    @IBAction func switchPressed(_ sender: AnyObject) {
        if let changeBlock = formSwitch.changeBlock {
            changeBlock(switchControl.isOn)
        }
    }
}
