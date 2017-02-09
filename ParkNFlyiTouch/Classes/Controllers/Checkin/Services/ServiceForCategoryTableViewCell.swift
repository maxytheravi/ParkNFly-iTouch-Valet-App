//
//  ServiceForCategoryTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/27/15.
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


@objc protocol ServiceForCategoryTableViewCellDelegate {
    @objc optional func selectService(_ serviceBo: ServiceBO)
}

class ServiceForCategoryTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var serviceDetailLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var oversizeChargeLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    var selectedServiceBo:ServiceBO?
    var indexPath:Int?
    var delegate:ServiceForCategoryTableViewCellDelegate?

    @IBAction func serviceDescriptionPopOverButtonAction(_ sender: UIButton) {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let customPopOverViewController = mainStroyboard.instantiateViewController(withIdentifier: "CustomPopOverViewController") as? CustomPopOverViewController
        
        customPopOverViewController!.modalPresentationStyle = UIModalPresentationStyle.popover
        customPopOverViewController!.preferredContentSize = CGSize(width: 500.0, height: 80.0)
        customPopOverViewController!.popoverPresentationController!.delegate = self
        
        customPopOverViewController!.popoverPresentationController!.sourceView = sender
        customPopOverViewController!.popoverPresentationController!.sourceRect = CGRect(x: sender.frame.size.width, y: sender.frame.size.height/2.0, width: 0, height: 0)
        customPopOverViewController!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
        customPopOverViewController!.popoverPresentationController?.backgroundColor = UIColor.white
        if selectedServiceBo?.serviceDesc?.characters.count > 0 && selectedServiceBo?.serviceDesc != nil {
        customPopOverViewController!.descriptionText = selectedServiceBo?.serviceDesc
            
        }else {
            let alert = UIAlertController(title: klError, message:kNoteNotAvailable, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            naviController!.present(alert, animated: true, completion: nil)
        }
        
        naviController!.present(customPopOverViewController!, animated: true, completion: { _ in })
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func selectedButtonAction(_ sender: AnyObject) {
        
        if self.delegate!.selectService != nil {
            self.delegate!.selectService!(self.selectedServiceBo!)
        }
        
        Utility.sharedInstance.appDelegate?.window!.endEditing(true)
    }
    
    func configureCell(_ serviceBo:ServiceBO, forIndexPath:Int) {
        
        self.selectedServiceBo = serviceBo
        self.indexPath = forIndexPath
        
        if let type:String = serviceBo.serviceName {
            self.serviceTypeLabel.text = type
        }
//        if let details:String = serviceBo.serviceDesc {
//            self.serviceDetailLabel.text = details
//        }
        if let rate = serviceBo.serviceCharge {
            self.rateLabel.text = Utility.getPriceString(rate)
        }
//        if let quantity:Int = serviceBo.quantity {
//            self.oversizeChargeLabel.text  =  String(quantity)
//        }
        if let oversizeCharge:Double = serviceBo.oversizeCharge {
            if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
                self.oversizeChargeLabel.text = Utility.getPriceString(naviController?.isOversizeVehicle == true ? oversizeCharge : 0.0)
            } else {
                self.oversizeChargeLabel.text = Utility.getPriceString(naviController?.ticketBO?.vehicleDetails?.isOversized == true ? oversizeCharge : 0.0)
            }
        }
        if serviceBo.isServiceSelected == true {
            selectedButton.setImage(UIImage(named: "Checked.png"), for: UIControlState())
        } else {
            selectedButton.setImage(UIImage(named: "Unchecked.png"), for: UIControlState())
        }
    }
}
