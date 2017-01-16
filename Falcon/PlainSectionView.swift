//
//  PlainSectionView.swift
//  Falcon
//
//  Created by Tayson Nguyen on 2016-07-20.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import UIKit

open class PlainSectionView: UITableViewHeaderFooterView {
    
    var isUppercase = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView(frame: self.bounds)
        backgroundView!.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        textLabel?.textColor = UIColor.gray
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if isUppercase {
            textLabel?.text = textLabel?.text?.uppercased()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
