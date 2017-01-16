//
//  SimpleCalendarCell.swift
//  CalendarTest
//
//  Created by Tayson Nguyen on 2015-09-23.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

class SimpleCalendarCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    var date: Date? {
        didSet {
            setupView()
        }
    }
    
    var day: Int? {
        guard let date = date else {
            return nil
        }

        let cal = Calendar.current
        let components = cal.dateComponents([.day], from: date)
        return components.day
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.layer.cornerRadius = 25
    }
    
    func setupView() {
        guard let day = day else {
            label.text = ""
            backgroundColor = UIColor.white
            return
        }
        
        let formatter = NumberFormatter()
        label.text = formatter.string(from: NSNumber(value: day))
        
        if isSelected {
            backgroundColor = UIColor.white
            label.textColor = tintColor
            
        } else {
            label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        }
    }
}
