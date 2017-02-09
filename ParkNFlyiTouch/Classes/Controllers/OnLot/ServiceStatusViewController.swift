//
//  ServiceStatusViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 11/01/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
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


class ServiceStatusViewController: BaseViewController, ServiceStatusCellDelegate {
    
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var oversizeSwitch: UISwitch!
    @IBOutlet weak var serviceStatusView: UIView!
    
    var services: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Service Status"
        
        self.services = NSMutableArray()
        
        if let _ = naviController?.ticketBO?.services {
            for serviceBO in (naviController?.ticketBO?.services)! {
                self.services?.add((serviceBO as! ServiceBO).deepCopyOfServiceBO())
            }
        }
        
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberLabel.text = naviController?.ticketBO?.prePrintedTicketNumber
        }else {
            self.ticketNumberLabel.text = naviController?.ticketBO?.barcodeNumberString
        }
        self.oversizeSwitch.isOn = (naviController?.ticketBO?.vehicleDetails?.isOversized)!
        
        self.updateServiceStatusViewColor()
        
        // Do any additional setup after loading the view.
    }
    
    func updateServiceStatusViewColor() {
        
        var redFound: Bool = false
        var yellowFound: Bool = false
        
        for serviceBOObject in self.services! {
            
            let serviceBO: ServiceBO = serviceBOObject as! ServiceBO
            
            if let _ = serviceBO.serviceCompleted {
                if serviceBO.serviceCompleted == "Completed" {
                    
                } else if serviceBO.serviceCompleted == "InProgress" {
                    yellowFound = true
                } else {
                    redFound = true
                    break
                }
            } else {
                redFound = true
                break
            }
        }
        
        if redFound == true {
            self.serviceStatusView.backgroundColor = UIColor.projectThemeRedColor(UIColor())()
            //                UIColor(red: 216.0/255.0, green: 29.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        } else if yellowFound == true {
            self.serviceStatusView.backgroundColor = UIColor.projectThemeYellowColor(UIColor())()
            //                UIColor(red: 238.0/255.0, green: 164.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        } else {
            self.serviceStatusView.backgroundColor = UIColor.projectThemeGreenColor(UIColor())()
            //                UIColor(red: 77.0/255.0, green: 169.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        }
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.services?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceStatusCell") as! ServiceStatusTableViewCell
        let serviceBO: ServiceBO = self.services![(indexPath as NSIndexPath).row] as! ServiceBO
        cell.delegate = self
        cell.configureCell(serviceBO)
        return cell
    }
    
    // MARK: Delegate methods
    func serviceStatusUpdated() {
        self.updateServiceStatusViewColor()
    }
    
    // MARK: Button Action methods
    @IBAction func saveButtonClicked(_ button: UIButton) {
        
        naviController?.ticketBO?.services = self.services
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let updateValetInfoService = UpdateValetInfoForTabletService()
        updateValetInfoService.delegate = self
        updateValetInfoService.updateValetInfoForTabletWebService(kUpdateValetInfoForTablet, parameters: ["Ticket":(naviController?.ticketBO)!])
        ActivityLogsManager.sharedInstance.logUserActivity(("Updated the status of services "  ), logType: "Normal")
    }
    
    @IBAction func oversizeSwitchValueChnaged(_ switchButton: UISwitch) {
        naviController?.ticketBO?.vehicleDetails?.isOversized = switchButton.isOn
        self.servicesTableView.reloadData()
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kUpdateValetInfoForTablet as String:
            
            let alert = UIAlertController(title: klSuccess, message: klSuccess, preferredStyle: UIAlertControllerStyle.alert)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Updated the status of services "  ), logType: "Normal")
            let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                _ = naviController?.popViewController(animated: true)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            break
            
        default:
            break
        }
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Receive Memory Warning methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
