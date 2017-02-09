//
//  SearchTicketViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/9/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class SearchTicketViewController: BaseViewController {

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search Ticket"
    }

    // MARK: UIButton action
    @IBAction func scanTicketButtonAction(_ sender: AnyObject) {
        let mainStroyboardId = Utility.createStoryBoardid(kMain)
        let scanViewController = mainStroyboardId.instantiateViewController(withIdentifier: "ScanViewController") as! ScanViewController
        scanViewController.scanType = ScanType.kPreprintedTicketForLookup
        naviController?.pushViewController(scanViewController, animated: true)
    }
    
    @IBAction func lookupButtonAction(_ sender: AnyObject) {
        
    }
 }
