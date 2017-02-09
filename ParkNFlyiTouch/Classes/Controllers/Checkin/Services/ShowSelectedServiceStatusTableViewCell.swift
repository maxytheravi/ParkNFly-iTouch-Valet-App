//
//  ShowSelectedServiceStatusTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/30/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol SelectedServiceStatusCellDelegate {
    @objc optional func serviceStatusUpdated()
}

class ShowSelectedServiceStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    
    @IBOutlet weak var serviceStatusView: UIView!
    @IBOutlet weak var serviceStatusButton: UIButton!
    
    var serviceBO:ServiceBO?
    var delegate:SelectedServiceStatusCellDelegate?
    
    @IBAction func serviceStatusButtonClicked(_ button: UIButton) {
        
        var serviceStatusActionSheet = UIAlertController()
        serviceStatusActionSheet = UIAlertController(title: "Select Service Status", message: nil, preferredStyle: .actionSheet)
        
        let completedAction = UIAlertAction(title: "Completed", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.serviceBO?.serviceCompleted = "Completed"
            self.configureCell(self.serviceBO!)
            self.delegate!.serviceStatusUpdated!()
        })
        serviceStatusActionSheet.addAction(completedAction)
        
        let inProgressAction = UIAlertAction(title: "In Progress", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.serviceBO?.serviceCompleted = "InProgress"
            self.configureCell(self.serviceBO!)
            self.delegate!.serviceStatusUpdated!()
        })
        serviceStatusActionSheet.addAction(inProgressAction)
        
        let toBeDoneAction = UIAlertAction(title: "To Be Done", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.serviceBO?.serviceCompleted = "ToBeDone"
            self.configureCell(self.serviceBO!)
            self.delegate!.serviceStatusUpdated!()
        })
        serviceStatusActionSheet.addAction(toBeDoneAction)
        
        let cancelAction = UIAlertAction(title: klCancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in})
        serviceStatusActionSheet.addAction(cancelAction)
        
        naviController?.present(serviceStatusActionSheet, animated: true, completion: nil)
    }
    
    func configureCell(_ serviceBO:ServiceBO) {
        
        self.serviceBO = serviceBO
        self.serviceNameLabel.text = serviceBO.serviceName!
        if let rate = serviceBO.serviceCharge {
            self.servicePriceLabel.text = Utility.getPriceString(rate)
        }
        
        var serviceStatus = ""
        if let _ = self.serviceBO!.serviceCompleted {
            if self.serviceBO!.serviceCompleted == "Completed" {
                self.serviceStatusView.backgroundColor = UIColor(red: 77.0/255.0, green: 169.0/255.0, blue: 106.0/255.0, alpha: 1.0)
                serviceStatus = "Completed"
            } else if self.serviceBO!.serviceCompleted == "InProgress" {
                self.serviceStatusView.backgroundColor = UIColor(red: 238.0/255.0, green: 164.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                serviceStatus = "In Progress"
            } else {
                self.serviceStatusView.backgroundColor = UIColor(red: 216.0/255.0, green: 29.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                serviceStatus = "To Be Done"
            }
        } else {
            self.serviceStatusView.backgroundColor = UIColor(red: 216.0/255.0, green: 29.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            serviceStatus = "To Be Done"
        }
        
        self.serviceStatusButton.setTitle(serviceStatus, for: UIControlState())
    }
}
