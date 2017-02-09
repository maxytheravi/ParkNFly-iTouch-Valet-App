//
//  BaseViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 13/10/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, GenericServiceManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func popingViewController() {
        
    }
    
    func connectionStatusUpdate(_ connectionStatus: Int32) {
        
    }
    
    func scannedBarcodeData(_ barcode: String!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
