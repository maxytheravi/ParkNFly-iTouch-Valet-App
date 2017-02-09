//
//  SerivceCategoryCell.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 02/02/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ServiceCategoryCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ serviceCategoryBO: ServiceCategoryBO) {
        self.titleLabel.text = serviceCategoryBO.serviceTypeName
    }
}
