//
//  FormDatePicker.swift
//  Falcon
//
//  Created by Tayson Nguyen on 2016-07-22.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class FormDatePicker: FormRowType {
    public var date: Date
    public var minuteInterval: Int
    
    public typealias ChangeBlock = (Date) -> ()
    public var changeBlock: ChangeBlock?
    
    public init(date: Date, minuteInterval: Int, changeBlock: ChangeBlock? = nil) {
        self.date = date;
        self.minuteInterval = minuteInterval
        self.changeBlock = changeBlock
    }
    
    // MARK: - TableViewRepresentable
    
    public static var cellClass: AnyClass {
        return FormDatePickerTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormDatePickerTableViewCell.reuseIdentifier, for: indexPath) as! FormDatePickerTableViewCell
        cell.formDatePicker = self
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
}
