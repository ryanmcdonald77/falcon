//
//  FormSwitch.swift
//  Habit
//
//  Created by Tayson on 2015-09-16.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class FormSwitch: FormRowType {
    public var title: String?
    public var on: Bool
    
    public typealias ChangeBlock = (Bool) -> ()
    public var changeBlock: ChangeBlock?
    
    public init(title: String? = nil, on: Bool = false, changeBlock: ChangeBlock? = nil) {
        self.title = title
        self.on = on
        self.changeBlock = changeBlock
    }
    
    // MARK: - TableViewRepresentable
    
    public static var cellClass: AnyClass {
        return FormSwitchTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormSwitchTableViewCell.reuseIdentifier, for: indexPath) as! FormSwitchTableViewCell
        cell.formSwitch = self
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
}
