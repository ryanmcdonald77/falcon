//
//  UITableView+Extension.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-08-25.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func reloadData(animated: Bool) {
        if animated {
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve,
                animations: { [unowned self] in
                self.reloadData()
            }, completion: nil)
 
        } else {
            reloadData()
        }
    }
}
