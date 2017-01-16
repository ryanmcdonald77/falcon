//
//  FormStepperTableViewCell.swift
//  Habit
//
//  Created by Tayson on 2015-09-16.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormStepperTableViewCell: UITableViewCell {

    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var valueLabel: UILabel!
    @IBOutlet open weak var stepper: UIStepper!

    fileprivate lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
        }()
    
    public var formStepper: FormStepper! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        titleLabel.text = formStepper.title
        valueLabel.text = formatter.string(from: NSNumber(value: formStepper.value))
        
        stepper.minimumValue = formStepper.min
        stepper.maximumValue = formStepper.max
        stepper.stepValue = formStepper.stepValue
        stepper.value = formStepper.value
        
        selectionStyle = .none
    }

    @IBAction func stepperPressed(_ sender: AnyObject) {
        valueLabel.text = formatter.string(from: NSNumber(value: stepper.value))
        formStepper.stepValue = stepper.value
        
        if let changeBlock = formStepper.changeBlock {
            changeBlock(stepper.value)
        }
    }
    
}


