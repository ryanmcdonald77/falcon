//
//  FormLabel2TableViewCell.swift
//  Falcon
//
//  Created by Tayson on 2016-02-08.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormLabel2TableViewCell: FormLabelTableViewCell {

    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView?.image == nil {
            constraint.constant = 15
        } else {
            constraint.constant = separatorInset.left
        }
    }
    
}
