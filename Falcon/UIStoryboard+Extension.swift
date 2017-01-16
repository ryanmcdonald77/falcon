//
//  UIStoryboard+Extension.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-08-26.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    public static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    public func viewController<T>(_ viewControllerClass: T.Type) -> T {
        let identifier = String(describing: viewControllerClass)
        return instantiateViewController(withIdentifier: identifier) as! T
    }
}
