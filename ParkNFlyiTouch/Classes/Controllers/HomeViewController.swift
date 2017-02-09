//
//  HomeViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 22/09/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        naviController!.dtdev!.disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UIButton action
    @IBAction func checkinButtonAction(_ sender: AnyObject) {
        naviController?.currentFlowStatus = FlowStatus.kCheckInFlow
    }
    
    @IBAction func checkoutButtonAction(_ sender: AnyObject) {
        
        naviController?.currentFlowStatus = FlowStatus.kCheckOutFlow
        
        if (naviController?.ticketBO?.barcodeNumberString != nil) {
            //display check out screen with ticket data
            let checkOutStroyboardId = Utility.createStoryBoardid(kCheckOut)
            let checkOutViewController = checkOutStroyboardId.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
            naviController?.pushViewController(checkOutViewController, animated: true)
            
        } else {
            //display lookup screen
            let checkinStroyboardId = Utility.createStoryBoardid(kMain)
            let searchTicketViewController = checkinStroyboardId.instantiateViewController(withIdentifier: "SearchTicketViewController") as! SearchTicketViewController
            naviController?.pushViewController(searchTicketViewController, animated: true)
        }
    }
    
    @IBAction func onlotButtonAction(_ sender: AnyObject) {
        
        naviController?.currentFlowStatus = FlowStatus.kOnLotFlow
        
        if (naviController?.ticketBO?.barcodeNumberString != nil) {
            //display onlot home screen
            let onlotStroyboardId = Utility.createStoryBoardid(kOnlot)
            let onlotViewController = onlotStroyboardId.instantiateViewController(withIdentifier: "OnLotHomeViewController") as! OnLotHomeViewController
            naviController?.pushViewController(onlotViewController, animated: true)
        }
        else {
            //display lookup screen
            let checkinStroyboardId = Utility.createStoryBoardid(kMain)
            let searchTicketViewController = checkinStroyboardId.instantiateViewController(withIdentifier: "SearchTicketViewController") as! SearchTicketViewController
            naviController?.pushViewController(searchTicketViewController, animated: true)
        }
    }
    
    @IBAction func shifcloseButtonAction(_ sender: AnyObject) {
        let shiftCloseManager:ShiftCloseService = ShiftCloseService()
        shiftCloseManager.delegate = self
        shiftCloseManager.shiftCloseWebService(kShiftClose, parameters: NSDictionary())
        ActivityLogsManager.sharedInstance.logUserActivity(("Shift close button is tapped"), logType: "Normal")
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch identifier {
        case kShiftClose as String:
            Utility.sharedInstance.loginViewController?.logout()
            
            break
            
        default:
            break
        }
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        
        switch identifier {
            
        case kShiftClose as String:
            Utility.sharedInstance.loginViewController?.logout()
//            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
            
            break
            
        default: break
        }
    }
    
}
