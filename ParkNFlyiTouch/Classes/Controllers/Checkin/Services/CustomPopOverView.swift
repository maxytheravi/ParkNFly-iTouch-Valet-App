//
//  CustomPopOverView.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 02/02/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class CustomPopOverView: UIView {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}
