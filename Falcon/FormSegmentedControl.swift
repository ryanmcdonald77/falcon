//
//  FormSegmentedControl.swift
//  Falcon
//
//  Created by Tayson Nguyen on 2016-11-10.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public struct Segment {
    public let title: String
    public let value: String
    
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}

public class FormSegmentedControl: FormRowType {
    public var title: String?
    public var segments: [Segment]
    public var selectedValue: String
    
    public typealias ChangeBlock = (Segment) -> ()
    public var changeBlock: ChangeBlock?
    
    public init(title: String? = nil, segments: [Segment], selectedValue: String, changeBlock: ChangeBlock? = nil) {
        self.title = title
        self.segments = segments
        self.selectedValue = selectedValue
        self.changeBlock = changeBlock
    }
    
    var selectedSegment: Segment {
        let segment = segments.first { $0.value == selectedValue }!
        return segment
    }
    
    var selectedSegmentIndex: Int {
        let index = segments.index { $0.value == selectedValue }!
        return index
    }
    
    // MARK: - TableViewRepresentable
    
    public static var cellClass: AnyClass {
        return FormSegmentedControlTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormSegmentedControlTableViewCell.reuseIdentifier, for: indexPath) as! FormSegmentedControlTableViewCell
        cell.formSegmentedControl = self
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
}
