//
//  FormLabel.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-13.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class FormLabel: FormRowType, TableViewCellSelectable {
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    
    public init(title: String? = nil, subtitle: String? = nil, image: UIImage? = nil, selectionBlock: CellSelectionBlock? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.cellSelectionBlock = selectionBlock
    }
    
    // MARK: - TableViewRepresentable
    
    public class var cellClass: AnyClass {
        return FormLabelTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormLabelTableViewCell.reuseIdentifier, for: indexPath) as! FormLabelTableViewCell
        cell.formLabel = self
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellSelectable
    
    public var cellSelectionBlock: CellSelectionBlock?
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
}
