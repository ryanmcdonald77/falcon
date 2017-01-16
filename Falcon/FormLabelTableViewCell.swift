//
//  FormLabelTableViewCell.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-13.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormLabelTableViewCell: UITableViewCell {

    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var subtitleLabel: UILabel!
    
    public var formLabel: FormLabel! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        titleLabel.text = formLabel.title
        subtitleLabel.text = formLabel.subtitle
        accessoryType = formLabel.cellSelectionBlock == nil ? .none : .disclosureIndicator
        
        if let image = formLabel.image {
            self.imageView?.image = image
        } else {
            self.imageView?.image = nil
        }
    }
}
