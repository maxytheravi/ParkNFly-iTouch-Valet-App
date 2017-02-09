//
//  ShowSelectedServiceTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/30/15.
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


@objc protocol switchButtonStatusDelegate {
    @objc optional func getSwitchButtonStatus(_ status:Bool, forServiceID:Int)
}

class ShowSelectedServiceTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var widthQuantityTextConstraint: NSLayoutConstraint!
    
    var serviceBO:ServiceBO?
    var serviceVC:ServicesViewController?
    var indexPath:IndexPath?
    var delegate:switchButtonStatusDelegate?
    
    func configureCell(_ serviceBO:ServiceBO, serviceVC: ServicesViewController, indexPath: IndexPath) {
        
        self.serviceVC = serviceVC
        self.indexPath = indexPath
        self.serviceBO = serviceBO
        self.serviceNameLabel.text = serviceBO.serviceName!
        
        if serviceBO.quantifiable == false {
            self.widthQuantityTextConstraint.constant = 0
            self.layoutIfNeeded()
            self.quantityTextField.isHidden = true
            self.quantityTextField.text = ""
        } else {
            self.widthQuantityTextConstraint.constant = 40
            self.layoutIfNeeded()
            self.quantityTextField.isHidden = false
            if let _ = serviceBO.quantity {
                self.quantityTextField.text = "\(serviceBO.quantity!)"
            } else {
                self.quantityTextField.text = ""
            }
        }
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        toolbarDone.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ShowSelectedServiceTableViewCell.doneButton_Clicked))
        ]
        self.quantityTextField.inputAccessoryView = toolbarDone
        
        if let rate = serviceBO.serviceCharge {
            
            var isOversizeVehicle = false
            if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
                isOversizeVehicle = (naviController?.isOversizeVehicle)!
            } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
                isOversizeVehicle = (naviController?.ticketBO?.vehicleDetails?.isOversized)!
            }
            
            var quantityRate: Double = 0.00
            if serviceBO.quantifiable == true {
                let quantity = Double((serviceBO.quantity)!)
                quantityRate = rate * quantity
            }else {
                quantityRate = rate
            }
            
            if isOversizeVehicle == true {
                let totalServiceCharge = quantityRate + serviceBO.oversizeCharge!
                self.servicePriceLabel.text = Utility.getPriceString(totalServiceCharge)
            }else {
                self.servicePriceLabel.text = Utility.getPriceString(quantityRate)
            }
        }
        switchButton.isOn = serviceBO.isSwitchOn
    }
    
    func doneButton_Clicked() {
        self.serviceVC?.view.endEditing(true)
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.serviceVC?.view.endEditing(true)
    }
    
    //MARK: Text Field Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.quantityTextField.text?.characters.count > 0 {
            self.serviceBO?.quantity = Int(self.quantityTextField.text!)
        } else {
            self.serviceBO?.quantity = 0
            self.quantityTextField.text = "0"
        }
        var quantityRate: Double = 0.00
        if self.serviceBO?.quantifiable == true {
            let quantity = Double((self.serviceBO?.quantity)!)
            quantityRate = (self.serviceBO?.serviceCharge)! * quantity
            self.servicePriceLabel.text = Utility.getPriceString(quantityRate)
        }else {
            quantityRate = (self.serviceBO?.serviceCharge)!
            self.servicePriceLabel.text = Utility.getPriceString(quantityRate)
        }
        self.serviceVC?.selectedServiceArray?[(self.indexPath?.row)!] = self.serviceBO!
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.serviceVC?.currentEditedTextField = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.serviceVC?.currentEditedTextField = nil
        return true
    }
    
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        if sender.isOn {
            self.serviceBO?.isSwitchOn = true
        } else {
            self.serviceBO?.isSwitchOn = false
        }
        if self.delegate?.getSwitchButtonStatus != nil {
            self.delegate?.getSwitchButtonStatus!((self.serviceBO?.isSwitchOn)!, forServiceID: (self.serviceBO?.serviceID)!)
        }
    }
    
    @IBAction func NotesBUttonAction(_ sender: UIButton) {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let customPopOverViewController = mainStroyboard.instantiateViewController(withIdentifier: "CustomPopOverViewController") as? CustomPopOverViewController
        
        customPopOverViewController!.modalPresentationStyle = UIModalPresentationStyle.popover
        customPopOverViewController!.preferredContentSize = CGSize(width: 500.0, height: 80.0)
        customPopOverViewController!.popoverPresentationController!.delegate = self
        
        customPopOverViewController!.popoverPresentationController!.sourceView = sender
        customPopOverViewController!.popoverPresentationController!.sourceRect = CGRect(x: sender.frame.size.width/2.0, y: 0, width: 0, height: 0)
        customPopOverViewController!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        customPopOverViewController!.popoverPresentationController?.backgroundColor = UIColor.white
        if serviceBO?.serviceNotes?.characters.count > 0 {
            customPopOverViewController!.descriptionText = serviceBO?.serviceNotes
            
        } else {
            let alert = UIAlertController(title: klError, message: kNoteNotAvailable, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            naviController!.present(alert, animated: true, completion: nil)
        }
        naviController!.present(customPopOverViewController!, animated: true, completion: { _ in })
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
