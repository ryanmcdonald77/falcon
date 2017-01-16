//
//  NSManagedObject+TableViewRepresentable.swift
//  Falcon
//
//  Created by Tayson on 2015-11-17.
//  Copyright © 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObject: TableViewRepresentable {
    
    public class var cellClass: AnyClass {
        return UITableViewCell.self
    }
    
    public func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = self.description
        return cell
    }
}
