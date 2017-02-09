//
//  SelectedDiscountTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 1/5/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol SelectedDiscountTableViewCellDelegate {
    
    @objc optional func getSwitchButtonStatus(_ selectedDiscountBO:DiscountInfoBO)
}

class SelectedDiscountTableViewCell: UITableViewCell {
    
    var discountBo:DiscountInfoBO?
    var indexPath:Int?
    var delegate :SelectedDiscountTableViewCellDelegate?
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var discountNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        
        if sender.isOn {
            self.discountBo?.isSwitchOn = true
        } else {
            self.discountBo?.isSwitchOn = false
        }
        
        if self.delegate?.getSwitchButtonStatus != nil {
            self.delegate?.getSwitchButtonStatus!(self.discountBo!)
        }
    }
    
    func configureCell(_ discountBo:DiscountInfoBO, forIndexPath:Int) {
        
        self.discountBo = discountBo
        self.indexPath = forIndexPath
        
        if let discountName = discountBo.discountName {
            self.discountNameLabel.text = discountName
        }
        
        self.switchButton.setOn(discountBo.isSwitchOn, animated: false)
    }
}
