//
//  FetchedDataSource.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-08-26.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class FetchedDataSource: NSObject {

    fileprivate var fetchRequest: NSFetchRequest<NSFetchRequestResult>
    fileprivate weak var tableView: UITableView!
    public var emptyDataSetView: EmptyDataSetView?
    fileprivate var tableViewSeparatorStyle: UITableViewCellSeparatorStyle = .none
    
    public typealias SelectionBlock = (NSManagedObject) -> ()
    public var selectionBlock: SelectionBlock?
    
    public var cellUpdateBlock: CellUpdateBlock?
    
    public typealias DeletionBlock = (NSManagedObject) -> ()
    public var deletionBlock: DeletionBlock?
    
    public var sectionNameKeyPath: String?
    
    public init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, tableView: UITableView) {
        let string = FalconRecord.bundleName.replacingOccurrences(of: " ", with: "_") + "." + fetchRequest.entityName!
        
        var entityClass: NSManagedObject.Type!
        if NSClassFromString(string) != nil {
            entityClass = NSClassFromString(string) as! NSManagedObject.Type
        } else {
            entityClass = NSClassFromString(fetchRequest.entityName!) as! NSManagedObject.Type
        }
        
        let cellClass = entityClass.cellClass as! UITableViewCell.Type
        tableView.register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.fetchRequest = fetchRequest
        self.tableView = tableView
        
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableViewSeparatorStyle = tableView.separatorStyle
    }
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: FalconRecord.viewContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            print(error)
        }
        
        return _fetchedResultsController!
    }
    
    fileprivate var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    fileprivate func objectAtIndexPath(_ indexPath: IndexPath) -> NSManagedObject {
        return fetchedResultsController.object(at: indexPath) as! NSManagedObject
    }
    
    fileprivate func updateEmptyDataSetView() {
        guard let emptyDataSetView = emptyDataSetView else {
            return
        }
        
        if _fetchedResultsController?.fetchedObjects?.count == 0 {
            if tableView.backgroundView != emptyDataSetView {
                emptyDataSetView.frame = tableView.bounds

                UIView.transition(with: emptyDataSetView, duration: 0.5, options: .transitionCrossDissolve,
                    animations: { [unowned self] in
                        self.tableView.backgroundView = emptyDataSetView
                        self.tableView.separatorStyle = .none
                        //print("ADDED VIEW")
                    }, completion: nil)
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
    
    public func reloadData() {
        _fetchedResultsController = nil
        tableView.reloadData()
    }
}

extension FetchedDataSource: TableViewCellUpdatable { }

extension FetchedDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        let sections = fetchedResultsController.sections?.count ?? 0
        updateEmptyDataSetView()
        return sections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = objectAtIndexPath(indexPath)
        let cell = object.representation(in: tableView, at: indexPath)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return deletionBlock != nil
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = objectAtIndexPath(indexPath)
            
            if let deletionBlock = deletionBlock {
                deletionBlock(object)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        
        if sectionInfo.name.isEmpty {
            return nil
        } else {
            return sectionInfo.name
        }
    }
    
    /*
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    
    }*/
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView.style == .plain  else {
            return nil
        }
        
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 0, width: tableView.frame.width - 15, height: 28)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14);
        label.text = self.tableView(tableView, titleForHeaderInSection: section)?.uppercased()
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28)
        headerView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        headerView.addSubview(label)
        return headerView;
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        guard tableView.style == .Plain  else {
//            return nil
//        }
//        
//        let label = UILabel()
//        label.frame = CGRect(x: 15, y: 0, width: tableView.frame.width - 15, height: 28)
//        label.textColor = UIColor.grayColor()
//        label.font = UIFont.systemFontOfSize(14);
//        label.text = self.tableView(tableView, titleForFooterInSection: section)
//        
//        let headerView = UIView()
//        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28)
//        headerView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
//        headerView.addSubview(label)
//        return headerView;
//    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard tableView.style == .plain  else {
            return UITableViewAutomaticDimension
        }
        
        guard self.tableView(tableView, titleForHeaderInSection: section) != nil else {
            return UITableViewAutomaticDimension
        }
        
        return 28
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        guard tableView.style == .Plain  else {
//            return UITableViewAutomaticDimension
//        }
//        
//        guard self.tableView(tableView, titleForFooterInSection: section) != nil else {
//            return UITableViewAutomaticDimension
//        }
//        
//        return 28
//    }
}

extension FetchedDataSource: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellUpdateBlock = cellUpdateBlock {
            cellUpdateBlock(cell)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = objectAtIndexPath(indexPath)
        selectionBlock?(object)
    }
}

extension FetchedDataSource: NSFetchedResultsControllerDelegate {
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView?.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
        updateEmptyDataSetView()
    }
}
