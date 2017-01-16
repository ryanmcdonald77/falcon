//
//  FormTextView.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-17.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class FormTextView: FormRowType {
    
    public var autoCorrectionType: UITextAutocorrectionType = .default
    public var autoCapitalizationType: UITextAutocapitalizationType = .sentences
    public var keyboardType: UIKeyboardType = .default
    
    public typealias ChangeBlock = (String) -> ()
    public var changeBlock: ChangeBlock?
    
    public var text: String?
    public var placeHolder: String?
    public var height: Double
    
    public init(text: String? = nil, placeHolder: String? = nil, height: Double = 80, changeBlock: ChangeBlock? = nil) {
        self.text = text
        self.placeHolder = placeHolder
        self.height = height
        self.changeBlock = changeBlock
        
        /*
        // call the change block right after init
        if let changeBlock = changeBlock {
            
            if let text = text {
                changeBlock(string: text)
            } else {
                changeBlock(string: "")
            }
        }*/
    }
    
    // MARK: - TableViewRepresentable
    
    public static var cellClass: AnyClass {
        return FormTextViewTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTextViewTableViewCell.reuseIdentifier, for: indexPath) as! FormTextViewTableViewCell
        cell.formTextView = self
        cell.frame.size = CGSize(width: cell.frame.size.width, height: CGFloat(height))
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
}
