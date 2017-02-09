//
//  ServiceStatusTableViewCell.swift
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


@objc protocol ServiceStatusCellDelegate {
    @objc optional func serviceStatusUpdated()
}

class ServiceStatusTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var notesButtonOutLet: UIButton!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var serviceStatusView: UIView!
    @IBOutlet weak var serviceStatusButton: UIButton!
    
    var serviceBO:ServiceBO?
    var delegate:ServiceStatusCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func NotesButtonAction(_ sender: UIButton) {
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let customPopOverViewController = mainStroyboard.instantiateViewController(withIdentifier: "CustomPopOverViewController") as? CustomPopOverViewController
        
        customPopOverViewController!.modalPresentationStyle = UIModalPresentationStyle.popover
        customPopOverViewController!.preferredContentSize = CGSize(width: 500.0, height: 80.0)
        customPopOverViewController!.popoverPresentationController!.delegate = self
        
        customPopOverViewController!.popoverPresentationController!.sourceView = sender
        customPopOverViewController!.popoverPresentationController!.sourceRect = CGRect(x: sender.frame.size.width/2.0, y: 0, width: 0, height: 0)
        customPopOverViewController!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        customPopOverViewController!.popoverPresentationController?.backgroundColor = UIColor.white
        if serviceBO?.serviceNotes?.characters.count > 0 && serviceBO?.serviceNotes != nil {
            customPopOverViewController!.descriptionText = serviceBO?.serviceNotes
            
        }else {
            let alert = UIAlertController(title: klError, message: kNoteNotAvailable, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            naviController!.present(alert, animated: true, completion: nil)
        }
        naviController!.present(customPopOverViewController!, animated: true, completion: { _ in })
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func serviceStatusButtonClicked(_ button: UIButton) {
        
        var serviceStatusActionSheet = UIAlertController()
        serviceStatusActionSheet = UIAlertController(title: "Select Service Status", message: nil, preferredStyle: .actionSheet)
        
        let completedAction = UIAlertAction(title: "Completed", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.serviceBO?.serviceCompleted = "Completed"
            ActivityLogsManager.sharedInstance.logUserActivity(("Status of " + (self.serviceBO?.serviceName)! + " is completed"  ), logType: "Normal")
            self.configureCell(self.serviceBO)
            self.delegate!.serviceStatusUpdated!()
        })
        serviceStatusActionSheet.addAction(completedAction)
        
        let inProgressAction = UIAlertAction(title: "In Progress", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.serviceBO?.serviceCompleted = "InProgress"
            ActivityLogsManager.sharedInstance.logUserActivity(("Status of " + (self.serviceBO?.serviceName)! + " InProgress"  ), logType: "Normal")
            self.configureCell(self.serviceBO)
            self.delegate!.serviceStatusUpdated!()
        })
        serviceStatusActionSheet.addAction(inProgressAction)
        
        let toBeDoneAction = UIAlertAction(title: "To Be Done", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.serviceBO?.serviceCompleted = "ToBeDone"
            ActivityLogsManager.sharedInstance.logUserActivity(("Status of " + (self.serviceBO?.serviceName)! + " ToBeDone"  ), logType: "Normal")
            self.configureCell(self.serviceBO)
            self.delegate!.serviceStatusUpdated!()
        })
        
        serviceStatusActionSheet.addAction(toBeDoneAction)
        
        let cancelAction = UIAlertAction(title: klCancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in})
        serviceStatusActionSheet.addAction(cancelAction)
        
        naviController?.present(serviceStatusActionSheet, animated: true, completion: nil)
    }
    
    func configureCell(_ serviceBO: ServiceBO?) {
        
        self.serviceBO = serviceBO
        
        self.serviceNameLabel.text = self.serviceBO!.serviceName
//        self.servicePriceLabel.text = Utility.getPriceString(self.serviceBO!.serviceCharge!)
        if let rate = self.serviceBO!.totalServiceCharge {
            if naviController?.ticketBO?.vehicleDetails?.isOversized == true {
                let totalServiceCharge = rate + self.serviceBO!.oversizeCharge!
                self.servicePriceLabel.text = Utility.getPriceString(totalServiceCharge)
            }else {
                self.servicePriceLabel.text = Utility.getPriceString(rate)
            }
        }
        
        var serviceStatus = ""
        if let _ = self.serviceBO!.serviceCompleted {
            if self.serviceBO!.serviceCompleted == "Completed" {
                self.serviceStatusView.backgroundColor = UIColor.projectThemeGreenColor(UIColor())()
                //                    UIColor(red: 77.0/255.0, green: 169.0/255.0, blue: 106.0/255.0, alpha: 1.0)
                serviceStatus = "Completed"
            } else if self.serviceBO!.serviceCompleted == "InProgress" {
                self.serviceStatusView.backgroundColor = UIColor.projectThemeYellowColor(UIColor())()
                //                    UIColor(red: 238.0/255.0, green: 164.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                serviceStatus = "In Progress"
            } else {
                self.serviceStatusView.backgroundColor = UIColor.projectThemeRedColor(UIColor())()
                //                    UIColor(red: 216.0/255.0, green: 29.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                serviceStatus = "To Be Done"
            }
        } else {
            self.serviceStatusView.backgroundColor = UIColor.projectThemeRedColor(UIColor())()
            //                UIColor(red: 216.0/255.0, green: 29.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            serviceStatus = "To Be Done"
        }
        
        self.serviceStatusButton.setTitle(serviceStatus, for: UIControlState())
    }
}
