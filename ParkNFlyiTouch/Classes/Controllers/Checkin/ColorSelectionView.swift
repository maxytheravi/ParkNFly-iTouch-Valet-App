//
//  ColorSelectionView.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 04/01/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol ColorSelectionViewDelegate {
    @objc optional func getSelectedColor(_ selectedColor: Int)
}

class ColorSelectionView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    var delegate: ColorSelectionViewDelegate?
    @IBOutlet var colorButtons : [UIButton]!
    
    override func awakeFromNib() {
        self.containerView.layer.borderWidth = 2.0
        self.containerView.layer.cornerRadius = 0
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.borderColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor
    }
    
    @IBAction func colorSelectionButtonAction(_ sender: UIButton) {
        
//        naviController?.popViewControllerAnimated(true)
        self.delegate?.getSelectedColor!(sender.tag)
        self.removeFromSuperview()
    }
    
    @IBAction func closeButtonAction(_ sender: AnyObject) {
//        naviController?.popViewControllerAnimated(true)
        self.removeFromSuperview()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
