//
//  FormStepper.swift
//  Habit
//
//  Created by Tayson on 2015-09-16.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class FormStepper: FormRowType {
    public var title: String?
    public var min: Double
    public var max: Double
    public var stepValue: Double
    public var value: Double
    
    public typealias ChangeBlock = (Double) -> ()
    public var changeBlock: ChangeBlock?
    
    public init(title: String? = nil, min: Double = 0, max: Double = 1, stepValue: Double = 1, value: Double = 0, changeBlock: ChangeBlock? = nil) {
        self.title = title
        self.min = min
        self.max = max
        self.stepValue = stepValue
        self.value = value
        self.changeBlock = changeBlock
        
        /*
        // call the change block right after init
        if let changeBlock = changeBlock {
            changeBlock(value: value)
        }*/
    }
    
    // MARK: - TableViewRepresentable
    
    public static var cellClass: AnyClass {
        return FormStepperTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormStepperTableViewCell.reuseIdentifier, for: indexPath) as! FormStepperTableViewCell
        cell.formStepper = self
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
}
