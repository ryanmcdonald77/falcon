//
//  TableViewRepresentable.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-08-26.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewRepresentable {
//    typealias T: UITableViewCell
    static var cellClass: AnyClass { get }
    
    func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

public typealias CellUpdateBlock = (UITableViewCell) -> ()
public protocol TableViewCellUpdatable {
    var cellUpdateBlock: CellUpdateBlock? { get set }
}

public typealias CellSelectionBlock = () -> () // should block have a cell parameter?
public protocol TableViewCellSelectable {
    var cellSelectionBlock: CellSelectionBlock? { get set }
    var shouldAutoDeselectRow: Bool { get set }
}

public typealias CellDeletionBlock = () -> () // should block have a cell parameter?
public protocol TableViewCellDeletable {
    var cellDeletionBlock: CellDeletionBlock? { get set }
}

public protocol TableViewCellEnableable {
    var enabled: Bool { get set }
}
