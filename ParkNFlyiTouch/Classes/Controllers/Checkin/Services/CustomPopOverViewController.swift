//
//  CustomPopOverViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 03/02/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class CustomPopOverViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var descriptionText: String?
    var isCustomerInfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let _ = self.descriptionText {
            self.descriptionTextView.text = self.descriptionText
        } else {
            self.descriptionTextView.text = ""
        }
        
        self.descriptionTextView.textAlignment = NSTextAlignment.center
        self.descriptionTextView.font = UIFont(name: "HelveticaNeue", size: 17.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isCustomerInfo == true {
            self.descriptionTextView.contentSize = self.descriptionTextView.bounds.size;
        } else if self.descriptionTextView.contentSize.height > 80 {
            self.preferredContentSize = CGSize(width: 500.0, height: self.descriptionTextView.contentSize.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
