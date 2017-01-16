//
//  FormTextField.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-13.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class FormTextField: FormRowType {
    
    public var autoCorrectionType: UITextAutocorrectionType = .default
    public var autoCapitalizationType: UITextAutocapitalizationType = .words
    public var keyboardType: UIKeyboardType = .default
    public var isSecureTextEntry: Bool = false
    
    public typealias ChangeBlock = (String) -> ()
    public var changeBlock: ChangeBlock?
    
    public var title: String?
    public var text: String?
    public var placeHolder: String?
    //var textAlignment
    
    public init(title: String? = nil, text: String? = nil, placeHolder: String? = nil, changeBlock: ChangeBlock? = nil) {
        self.title = title
        self.text = text
        self.placeHolder = placeHolder
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
        return FormTextFieldTableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTextFieldTableViewCell.reuseIdentifier, for: indexPath) as! FormTextFieldTableViewCell
        cell.formTextField = self
        return cell
    }
    
    // MARK: - TableViewCellUpdatable
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    // MARK: - TableViewCellDeletable
    
    public var cellDeletionBlock: CellDeletionBlock?
    
    // MARK: - TableViewCellEnableable
    
    public var enabled: Bool = true
}
