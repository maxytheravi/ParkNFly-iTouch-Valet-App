//
//  CheckOutViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/3/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CheckOutViewController: BaseViewController {
    
    /** UILabel outlet for ticketNumber Label.
     */
    @IBOutlet weak var ticketNumberLabel: UILabel!
    /** UILabel outlet for balance Label.
     */
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet var rfdsButtons : [DesignableButton]!
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button: DesignableButton in rfdsButtons {
            
            switch (button.tag) {
            case 1:
                if naviController?.ticketBO?.reservationsArray != nil && naviController?.ticketBO?.reservationsArray?.count > 0 {
                    button.backgroundColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0)
                    button.setTitleColor(UIColor.white, for: UIControlState())
                }
                break
                
            case 2:
                if naviController?.ticketBO?.identifierKey != nil && naviController?.ticketBO?.identifierKey?.characters.count > 0 {
                    button.backgroundColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0)
                    button.setTitleColor(UIColor.white, for: UIControlState())
                }
                break
                
            case 3:
                if naviController?.ticketBO?.discounts != nil && naviController?.ticketBO?.discounts?.count > 0 {
                    button.backgroundColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0)
                    button.setTitleColor(UIColor.white, for: UIControlState())
                }
                break
                
            case 4:
                if naviController?.ticketBO?.services != nil && naviController?.ticketBO?.services?.count > 0 {
                    button.backgroundColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0)
                    button.setTitleColor(UIColor.white, for: UIControlState())
                }
                break
                
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let calculateRateManager:CalculateRateService = CalculateRateService()
        calculateRateManager.delegate = self
        calculateRateManager.calculateRateWebService(kCalculateRate, parameters:["TicketDetails": (naviController?.ticketBO)!])
    }
    
    func updateDetailsFromResponses(_ calculateRateDict: NSDictionary) {
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberLabel.text = (naviController?.ticketBO?.prePrintedTicketNumber)!
        }else {
            self.ticketNumberLabel.text = (naviController?.ticketBO?.barcodeNumberString)!
        }
        self.balanceLabel.text = "$ " + calculateRateDict.getInnerText(forKey: "a:TotalCharge") as String
    }
    
    override func popingViewController() {
        naviController!.clearDataOnAppFlowChanged()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UIButton action
    @IBAction func rfdsButtonsAction(_ button: UIButton) {
        
//        button.backgroundColor = UIColor(red: 3.0/255.0, green: 39.0/255.0, blue: 81.0/255.0, alpha: 1.0)
//        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
//            button.backgroundColor = UIColor(red: 212.0/255.0, green: 252.0/255.0, blue: 227.0/255.0, alpha: 1.0)
//            button.setTitleColor(UIColor(red: 3.0/255.0, green: 39.0/255.0, blue: 81.0/255.0, alpha: 1.0), forState: .Normal)
//        }
    }
    
    @IBAction func reservationButtonAction(_ sender: AnyObject) {
    }
    
    @IBAction func frequentParkerButtonAction(_ sender: AnyObject) {
    }
    
    @IBAction func discountButtonAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func servicesButtonAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func addDiscountReservationMethod(_ sender: AnyObject) {
    }
    
    @IBAction func payButtonAction(_ sender: AnyObject) {
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        let calculateRateDict: NSDictionary = response as! NSDictionary
        self.updateDetailsFromResponses(calculateRateDict)
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
