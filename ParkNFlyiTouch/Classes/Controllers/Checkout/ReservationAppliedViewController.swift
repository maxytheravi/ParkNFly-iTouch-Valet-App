//
//  ReservationAppliedViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/4/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ReservationAppliedViewController: BaseViewController {
    
    var ticketBO:TicketBO?
    
    @IBOutlet weak var balanceDueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let calculateRateManager:CalculateRateService = CalculateRateService()
        calculateRateManager.delegate = self
        calculateRateManager.calculateRateWebService(kCalculateRate, parameters:["TicketDetails": ticketBO! ])
    }
    
    func updateDetailsFromResponses(_ calculateRateDict: NSDictionary) {
        self.balanceDueLabel.text = "Balance Due: $ " + calculateRateDict.getInnerText(forKey: "a:TotalCharge") as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
