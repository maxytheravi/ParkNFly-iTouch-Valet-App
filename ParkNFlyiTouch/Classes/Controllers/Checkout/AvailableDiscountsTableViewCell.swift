//
//  AvailableDiscountsTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 1/5/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol AvailableDiscountsTableViewCellDelegate {
    @objc optional func getSelectedDiscount(_ selectedDiscount: DiscountInfoBO)
    @objc optional func addDiscount(_ selectedDiscount: DiscountInfoBO)
}

class AvailableDiscountsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var discountselectionButton: UIButton!
    @IBOutlet weak var discountNameLabel: UILabel!
    
    var discountBo:DiscountInfoBO?
    var indexPath:Int?
    var delegate:AvailableDiscountsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func quantityButtonAction(_ sender: AnyObject) {
        if discountBo?.isDiscountSelected == true {
            if discountBo?.allowMultiple == true {
                
                Utility.sharedInstance.appDelegate?.window!.endEditing(true)
                
                if let selectedDiscountDetails = self.discountBo {
                    self.delegate?.addDiscount!(selectedDiscountDetails)
                }
            }
        }
    }
    
    @IBAction func discountSelectionButtonAction(_ sender: UIButton) {
        //on click of button send selected discount data to DiscountViewController's selectedDiscounts tableview
        
        let button: UIButton = sender
        button.isSelected = !button.isSelected
        self.discountBo?.isDiscountSelected = button.isSelected
        Utility.sharedInstance.appDelegate?.window!.endEditing(true)
        
        if let selectedDiscountDetails = self.discountBo {
            self.delegate?.getSelectedDiscount!(selectedDiscountDetails)
        }
    }
    
    func configureCell(_ discountBo:DiscountInfoBO, forIndexPath:Int) {
        
        self.discountBo = discountBo
        self.indexPath = forIndexPath
        
        if let discountName = discountBo.discountName {
            self.discountNameLabel.text = discountName
        }
        self.discountselectionButton.isSelected = discountBo.isDiscountSelected
    }
}
