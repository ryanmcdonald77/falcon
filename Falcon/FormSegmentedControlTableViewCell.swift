//
//  FormSegmentedControlTableViewCell.swift
//  Falcon
//
//  Created by Tayson Nguyen on 2016-11-10.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormSegmentedControlTableViewCell: UITableViewCell {

    @IBOutlet open weak var label: UILabel!
    @IBOutlet open weak var segmentedControl: UISegmentedControl!
    
    public var formSegmentedControl: FormSegmentedControl! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        label.text = formSegmentedControl.title
        
        segmentedControl.removeAllSegments()
        for segment in formSegmentedControl.segments.reversed() {
            segmentedControl.insertSegment(withTitle: segment.title, at: 0, animated: false)
        }
        segmentedControl.selectedSegmentIndex = formSegmentedControl.selectedSegmentIndex
        selectionStyle = .none
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        if let changeBlock = formSegmentedControl.changeBlock {
            let segment = formSegmentedControl.segments[segmentedControl.selectedSegmentIndex]
            changeBlock(segment)
        }
    }
}
