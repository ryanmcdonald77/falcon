//
//  EmptyDataSetView.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-10-10.
//  Copyright © 2015 Tayson Nguyen. All rights reserved.
//

import UIKit

open class EmptyDataSetView: UIView {

    public typealias ButtonPressedBlock = () -> ()
    open var buttonPressedBlock: ButtonPressedBlock?
    
    @IBOutlet open weak var imageView: UIImageView!
    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var messageLabel: UILabel!
    @IBOutlet open weak var button: UIButton!
    
    var view: UIView!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    public convenience init(image: UIImage?, title: String?, message: String?, buttonTitle: String?, buttonPressedBlock: ButtonPressedBlock?) {
        self.init()
        
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        button.setTitle(buttonTitle, for: UIControlState())
        self.buttonPressedBlock = buttonPressedBlock
        
        imageView.isHidden = image == nil
        titleLabel.isHidden = title == nil
        messageLabel.isHidden = message == nil
        button.isHidden = buttonTitle == nil
    }
    
    func setupXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EmptyDataSetView", bundle: bundle)
        
        view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        if let buttonPressedBlock = buttonPressedBlock {
            buttonPressedBlock()
        }
    }
}
