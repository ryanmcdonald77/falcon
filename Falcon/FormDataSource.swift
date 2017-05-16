//
//  FormDataSource.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-13.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class FormDataSource: NSObject {
    fileprivate weak var tableView: UITableView?
    
    public typealias FormBlock = () -> ([FormSection])
    fileprivate var formBlock: FormBlock
    
    fileprivate var formSections: [FormSection] {
        didSet {
            updateEmptyDataSetView()
        }
    }
    
    public var emptyDataSetView: EmptyDataSetView?
    fileprivate var tableViewSeparatorStyle: UITableViewCellSeparatorStyle = .none
    
    public init(tableView: UITableView, formBlock: @escaping FormBlock) {
        tableViewSeparatorStyle = tableView.separatorStyle
        
        self.tableView = tableView
        self.formBlock = formBlock
        formSections = formBlock()
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        self.registerNibs()
    }
    
    fileprivate func registerNibs() {
        for section in formSections {
            for row in section.rows {
                let type = type(of: row).cellClass as! UITableViewCell.Type
                tableView?.register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
            }
            
            tableView?.register(section.headerViewType, forHeaderFooterViewReuseIdentifier: String(describing: section.headerViewType))
            tableView?.register(section.footerViewType, forHeaderFooterViewReuseIdentifier: String(describing: section.footerViewType))
        }
    }
    
    fileprivate func objectAtIndexPath(_ indexPath: IndexPath) -> FormRowType {
        return formSections[indexPath.section].rows[indexPath.row]
    }
    
    public func reloadData(animated: Bool) {
        formSections = formBlock()
        self.registerNibs()
        tableView?.reloadData(animated: animated)
    }
    
    fileprivate func updateEmptyDataSetView() {
        guard let emptyDataSetView = emptyDataSetView else {
            return
        }
        
        guard let tableView = tableView else {
            return
        }
        
        let rows = formSections.map { $0.rows.count }.reduce(0) { $0 + $1 }
        
        if rows == 0 {
            if tableView.backgroundView != emptyDataSetView {
                emptyDataSetView.frame = tableView.bounds
                
                //UIView.transitionWithView(emptyDataSetView, duration: 0.5, options: .TransitionCrossDissolve,
                    //animations: { [unowned self] in
                        self.tableView?.backgroundView = emptyDataSetView
                        self.tableView?.separatorStyle = .none
                        //print("ADDED VIEW")
                    //}, completion: nil)
            }
            
        } else {
            
            if let backgroundView = tableView.backgroundView {
                let mirror = Mirror(reflecting: backgroundView)
                if mirror.subjectType == EmptyDataSetView.self {
                    tableView.backgroundView = nil
                    tableView.separatorStyle = tableViewSeparatorStyle
                    //print("REMOVED VIEW")
                }
            }
        }
    }
}

extension FormDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return formSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= formSections.count {
            return 0
        }
        
        return formSections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let object = objectAtIndexPath(indexPath)
        return object.cellDeletionBlock != nil
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = objectAtIndexPath(indexPath)
            
            if let cellDeletionBlock = object.cellDeletionBlock {
                cellDeletionBlock()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = objectAtIndexPath(indexPath)
        let cell = object.representation(in: tableView, at: indexPath)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= formSections.count {
            return nil
        }
        
        return formSections[section].header
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section >= formSections.count {
            return nil
        }
        
        return formSections[section].footer
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard tableView.style == .plain else {
            return UITableViewAutomaticDimension
        }
        
        guard formSections[section].header != nil else {
            return UITableViewAutomaticDimension
        }

        return CGFloat(formSections[section].headerHeight)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard tableView.style == .plain else {
            return UITableViewAutomaticDimension
        }
        
        guard formSections[section].footer != nil  else {
            return UITableViewAutomaticDimension
        }

        return CGFloat(formSections[section].footerHeight)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView.style == .plain else {
            return nil
        }
        
        let type = formSections[section].headerViewType
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) else {
            return nil
        }
        
        if let configBlock = formSections[section].headerConfigBlock {
            configBlock(view)
        }
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard tableView.style == .plain  else {
            return nil
        }
        
        let type = formSections[section].footerViewType
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) else {
            return nil
        }
        
        if let configBlock = formSections[section].footerConfigBlock {
            configBlock(view)
        }
        
        return view
    }
}

extension FormDataSource: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let object = objectAtIndexPath(indexPath)

        if let cellUpdateBlock = object.cellUpdateBlock {
            cellUpdateBlock(cell)
        }
        
        if object.enabled {
            cell.alpha = 1.0
            cell.isUserInteractionEnabled = true
        } else {
            cell.alpha = 0.5
            cell.isUserInteractionEnabled = false
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let formRow = objectAtIndexPath(indexPath) as? TableViewCellSelectable else {
            // this row is not selectable
            return
        }
        
        if formRow.shouldAutoDeselectRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if let cellSelectionBlock = formRow.cellSelectionBlock {
            cellSelectionBlock()
        }
    }
}
