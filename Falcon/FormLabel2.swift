//
//  FormLabel2.swift
//  Falcon
//
//  Created by Tayson on 2016-02-08.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import UIKit

public class FormLabel2: FormLabel {
    
    // MARK: - TableViewRepresentable
    
    public override static var cellClass: AnyClass {
        return FormLabel2TableViewCell.self
    }
    
    public override func representation(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormLabel2TableViewCell.reuseIdentifier, for: indexPath) as! FormLabel2TableViewCell
        cell.formLabel = self
        return cell
    }
}
