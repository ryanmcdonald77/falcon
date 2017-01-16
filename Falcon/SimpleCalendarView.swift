//
//  SimpleCalendarView.swift
//  CalendarTest
//
//  Created by Tayson on 2015-09-22.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

@IBDesignable open class SimpleCalendarView: UIView {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var preferredCellHeight: Double = 0
    var view: UIView!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    func setupXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SimpleCalendarView", bundle: bundle)
        
        view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        let cellNib = UINib(nibName: "SimpleCalendarCell", bundle: bundle)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "Cell")
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        //leftButton.tintColor = tintColor
        //rightButton.tintColor = tintColor
        
        let dayNames = cal.shortWeekdaySymbols 
        sunLabel.text = dayNames[0]
        monLabel.text = dayNames[1]
        tueLabel.text = dayNames[2]
        wedLabel.text = dayNames[3]
        thuLabel.text = dayNames[4]
        friLabel.text = dayNames[5]
        satLabel.text = dayNames[6]
        
        updateView()
    }
    
    func updateView() {
        monthLabel.text = monthLabelFormatter.string(from: currentMonth)
        
        if let firstMonth = firstMonth {
            let firstMonthComp = cal.dateComponents([.year, .month], from: firstMonth)
            let currentMonthComp = cal.dateComponents([.year, .month], from: currentMonth)
            leftButton.isHidden = firstMonthComp == currentMonthComp
            
        } else {
            leftButton.isHidden = false
        }
        
        if let lastMonth = lastMonth {
            let lastMonthComp = cal.dateComponents([.year, .month], from: lastMonth)
            let currentMonthComp = cal.dateComponents([.year, .month], from: currentMonth)
            rightButton.isHidden = lastMonthComp == currentMonthComp
            
        } else {
            rightButton.isHidden = false
        }
    }
    
    lazy var monthLabelFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    public var selectedDates: [Date] = [Date]() {
        didSet {
            updateView()
            collectionView.reloadData()
        }
    }
    public var firstMonth: Date?
    public var lastMonth: Date?
    
    public typealias DateSelectionBlock = (Date) -> ()
    public var dateSelectionBlock: DateSelectionBlock?
    
    
    var currentMonth: Date = Date()
    
    var cal = Calendar.current
    
    var numberOfDaysInMonth: Int {
        let days = (cal as NSCalendar).range(of: .day, in: .month, for: currentMonth)
        return days.length
    }
    
    var firstDayOfMonth: Date {
        var components = cal.dateComponents([.year, .month, .day], from: currentMonth)
        components.day = 1
        return cal.date(from: components)!
    }
    
    var weekDayForFirstDayOfMonth: Int {
        let components = cal.dateComponents([.weekday], from: firstDayOfMonth)
        return components.weekday!
    }
    
    var indexOfFirstDayOfMonth: Int {
        return weekDayForFirstDayOfMonth - 1
    }
    
    func dateForDayInCurrentMonth(_ day: Int) -> Date {
        var components = cal.dateComponents([.year, .month, .day], from: currentMonth)
        components.day = day
        return cal.date(from: components)!
    }
    
    @IBAction func previousMonth() {
        var components = cal.dateComponents([.year, .month, .day], from: currentMonth)
        components.month! -= 1
        currentMonth = cal.date(from: components)!
        updateView()
        //collectionView.reloadData()
        
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.invalidateIntrinsicContentSize()
            self.superview?.layoutIfNeeded()
            self.collectionView.reloadData()
        }) 
    }
    
    @IBAction func nextMonth() {
        var components = cal.dateComponents([.year, .month, .day], from: currentMonth)
        components.month! += 1
        currentMonth = cal.date(from: components)!
        updateView()
        //collectionView.reloadData()

        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.invalidateIntrinsicContentSize()
            self.superview?.layoutIfNeeded()
            self.collectionView.reloadData()
        }) 
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
        self.preferredCellHeight = Double(floor((view.frame.size.width - 6) / 7))
        self.invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
    
    open override var intrinsicContentSize : CGSize {
        let numberOfCells = Double(numberOfDaysInMonth + indexOfFirstDayOfMonth)
        let numberOfRows = Double(ceil(numberOfCells / 7.0))
        let float = preferredCellHeight * numberOfRows + 66 + numberOfRows - 1
        let height = CGFloat(float)
        
        return CGSize(width: UIViewNoIntrinsicMetric, height:height)
    }
}

extension SimpleCalendarView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth + indexOfFirstDayOfMonth
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SimpleCalendarCell
        
        cell.tintColor = tintColor
        if indexPath.row < indexOfFirstDayOfMonth {
            cell.date = nil
        
        } else {
            let day = indexPath.row - indexOfFirstDayOfMonth + 1
            let date = dateForDayInCurrentMonth(day)
            
            let found = selectedDates.map { (date) -> Date in
                let cal = Calendar.current
                let comps = cal.dateComponents([.year, .month, .day], from: date)
                return cal.date(from: comps)!

                }.filter { ($0 == date) }
            
            if !found.isEmpty {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }

            cell.date = date
        }
        
        return cell
    }
}

extension SimpleCalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = floor((view.frame.size.width - 6) / 7)
        return CGSize(width: preferredCellHeight, height: preferredCellHeight)
    }
}

extension SimpleCalendarView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dateSelectionBlock = dateSelectionBlock else {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! SimpleCalendarCell
        
        guard let date = cell.date else {
            return
        }
        
        dateSelectionBlock(date)
    }
}
