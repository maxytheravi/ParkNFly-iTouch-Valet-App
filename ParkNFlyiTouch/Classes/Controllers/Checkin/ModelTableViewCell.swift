//
//  ModelTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 05/02/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ModelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCellForVehicleModel(_ modelName: String) {
        
        self.nameLabel.text = modelName
        
        switch (modelName) {
        case "AWD/4WD":
            self.modelImageView.image = UIImage(named:"AWD.jpg")
            break
        case "Convertible":
            self.modelImageView.image = UIImage(named:"Convertabile.jpg")
            break
        case "Coupe":
            self.modelImageView.image = UIImage(named:"Coupe.jpg")
            break
        case "Hatchback":
            self.modelImageView.image = UIImage(named:"Hatchback.jpg")
            break
        case "Hybrid/Electric":
            self.modelImageView.image = UIImage(named:"Hybrid.jpg")
            break
        case "Luxury":
            self.modelImageView.image = UIImage(named:"Luxury.jpg")
            break
        case "Sedan":
            self.modelImageView.image = UIImage(named:"Sedan.jpg")
            break
        case "SUV/CrossOver":
            self.modelImageView.image = UIImage(named:"SUV.jpg")
            break
        case "Truck":
            self.modelImageView.image = UIImage(named:"Truck.jpg")
            break
        case "Van/Minivan":
            self.modelImageView.image = UIImage(named:"Van.jpg")
            break
        case "Wagon":
            self.modelImageView.image = UIImage(named:"Wagon.jpg")
            break
        default:
            break
        }
    }
    
}
