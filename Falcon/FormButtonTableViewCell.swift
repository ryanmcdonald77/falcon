//
//  FormButtonTableViewCell.swift
//  Habit
//
//  Created by Tayson on 2015-09-16.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormButtonTableViewCell: UITableViewCell {

    @IBOutlet open weak var button: UIButton!
    
    public var formButton: FormButton! {
        didSet {
            setupView()
        }
    }

    func setupView() {
        button.setTitle(formButton.title, for: UIControlState())
        selectionStyle = .none
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        if let cellSelectionBlock = formButton.cellSelectionBlock {
            cellSelectionBlock()
        }
    }
}
