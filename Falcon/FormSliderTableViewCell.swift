//
//  FormSliderTableViewCell.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-09-17.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class FormSliderTableViewCell: UITableViewCell {

    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var valueLabel: UILabel!
    @IBOutlet open weak var slider: UISlider!
    
    fileprivate lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
        }()
    
    public var formSlider: FormSlider! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        titleLabel.text = formSlider.title
        valueLabel.text = formatter.string(from: NSNumber(value: formSlider.value))
        
        slider.minimumValue = Float(formSlider.min)
        slider.maximumValue = Float(formSlider.max)
        slider.value = Float(formSlider.value)
        
        selectionStyle = .none
    }
    
    @IBAction func sliderChanged(_ sender: AnyObject) {
        let sliderValue = round(Double(slider.value) / formSlider.stepValue) * formSlider.stepValue
        
        valueLabel.text = formatter.string(from: NSNumber(value: sliderValue))
        formSlider.value = sliderValue
        slider.value = Float(sliderValue)
        
        if let changeBlock = formSlider.changeBlock {
            changeBlock(sliderValue)
        }
    }
    
}
