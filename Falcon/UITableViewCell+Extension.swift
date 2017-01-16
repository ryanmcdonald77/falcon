//
//  UITableViewCell+Extension.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-09.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: self.reuseIdentifier, bundle: bundle)
    }
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
