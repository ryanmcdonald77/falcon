//
//  FormButton.swift
//  Habit
//
//  Created by Tayson on 2015-09-16.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class FormButton: FormRowType, TableViewCellSelectable {
    public var title: String?
    
    public init(title: String? = nil, selectionBlock: CellSelectionBlock? = nil) {
        self.title = title
        self.cellSelectionBlock = selectionBlock
        self.shouldAutoDeselectRow = true
    }
    
    // MARK: - TableViewRepresentable
    
    public static var cellClass: AnyClass {
        return FormButtonTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormButtonTableViewCell.reuseIdentifier, for: indexPath) as! FormButtonTableViewCell
        cell.formButton = self
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellSelectable
    
    public var cellSelectionBlock: CellSelectionBlock?
    public var shouldAutoDeselectRow: Bool
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
    
}
