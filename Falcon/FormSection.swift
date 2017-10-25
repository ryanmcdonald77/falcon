//
//  FormSection.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-13.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation

public class FormSection {
    public var header: String? {
        didSet {
            guard headerViewType == nil else { return }
            if header == nil {
                headerViewType = nil
            } else {
                headerViewType = PlainSectionView.self
            }
        }
    }
    public var footer: String? {
        didSet {
            guard footerViewType == nil else { return }
            if footer == nil {
                footerViewType = nil
            } else {
                footerViewType = PlainSectionView.self
            }
        }
    }
    
    public var rows: [FormRowType] = []
    
    public typealias SectionViewConfigBlock = (UITableViewHeaderFooterView) -> ()
    
    fileprivate(set) var headerViewType: UITableViewHeaderFooterView.Type? = nil
    fileprivate(set) var headerConfigBlock: SectionViewConfigBlock? = { (view) in
        let plainSectionView = view as! PlainSectionView
        plainSectionView.isUppercase = true
    }
    public var headerHeight = 28
    
    fileprivate(set) var footerViewType: UITableViewHeaderFooterView.Type? = nil
    fileprivate(set) var footerConfigBlock: SectionViewConfigBlock?
    public var footerHeight = 28
    
    public func headerView<T: UITableViewHeaderFooterView>(type: T.Type, configBlock: SectionViewConfigBlock?) {
        headerViewType = type
        headerConfigBlock = configBlock
    }
    
    public func footerView<T: UITableViewHeaderFooterView>(type: T.Type, configBlock: SectionViewConfigBlock?) {
        footerViewType = type
        footerConfigBlock = configBlock
    }
    
    public init(header: String? = nil, footer: String? = nil, rows: [FormRowType]? = []) {
        self.header = header
        if header != nil {
            self.headerViewType = PlainSectionView.self
        }
        self.footer = footer
        if footer != nil {
            self.footerViewType = PlainSectionView.self
        }
        if let rows = rows {
            self.rows = rows
        }
    }
}
