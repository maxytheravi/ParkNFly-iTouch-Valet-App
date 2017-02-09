//
//  SpaceNumberViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/27/15.
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


class SpaceNumberViewController: BaseViewController {
    
    @IBOutlet weak var currentLocationTextField: UITextField!
    @IBOutlet weak var spaceNumberTextField: UITextField!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    
    //MARK: - ViewCo
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Update Space"
        
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberLabel.text = naviController?.ticketBO?.prePrintedTicketNumber
        }else {
            self.ticketNumberLabel.text = naviController?.ticketBO?.barcodeNumberString
        }
        currentLocationTextField.text = (naviController?.ticketBO?.spaceDescription)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - ButtonAction
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        naviController?.ticketBO?.spaceDescription = spaceNumberTextField.text
        _ = naviController?.popViewController(animated: true)
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
