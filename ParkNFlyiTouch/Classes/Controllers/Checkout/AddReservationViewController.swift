//
//  AddReservationViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/4/15.
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


class AddReservationViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var reservationTextView: UITextView!
    @IBOutlet weak var reservationTextField: TextField!
    @IBOutlet weak var reservationsLabel: UILabel!
    
    var selectedReservationArray:[ReservationAndFPCardDetailsBO]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.selectedReservationArray = [ReservationAndFPCardDetailsBO]()
        
        if let _ = naviController?.ticketBO?.reservationsArray {
            for reservation in (naviController?.ticketBO?.reservationsArray)! {
                self.selectedReservationArray?.append(reservation)
            }
        }
        
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketLabel.text = (naviController?.ticketBO?.prePrintedTicketNumber)! as String
        }else {
            self.ticketLabel.text = (naviController?.ticketBO?.barcodeNumberString)! as String
        }
        self.reFreshView(self.selectedReservationArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reservationTextField.text = ""
    }
    
    func reFreshView(_ reservationsArray:[ReservationAndFPCardDetailsBO]?) {
        
        if reservationsArray?.count > 0 {
            var reservationString: String = ""
            var reservationDetailsString: String = ""
            
            for reservation in reservationsArray! {
                
                if reservationString != "" {
                    reservationString += reservation.reservationCode! + ","
                }else {
                    reservationString = reservation.reservationCode! + ","
                }
                
                if reservationDetailsString != "" {
                    reservationDetailsString = reservationDetailsString + (reservation.reservationCode == nil ? "" : (reservation.reservationCode)!) + "\n" + (reservation.firstName == nil ? "" : (reservation.firstName)!) + " " + (reservation.lastName == nil ? "" : (reservation.lastName)!) + "\n" + (reservation.parkingTypeName == nil ? "" : (reservation.parkingTypeName)!) + "\n" + (reservation.fromDate == nil ? "" : (reservation.fromDate)!) + " to " + (reservation.toDate == nil ? "" : (reservation.toDate)!) + "\n\n"
                }else {
                    reservationDetailsString = (reservation.reservationCode == nil ? "" : (reservation.reservationCode)!) + "\n" + (reservation.firstName == nil ? "" : (reservation.firstName)!) + " " + (reservation.lastName == nil ? "" : (reservation.lastName)!) + "\n" + (reservation.parkingTypeName == nil ? "" : (reservation.parkingTypeName)!) + "\n" + (reservation.fromDate == nil ? "" : (reservation.fromDate)!) + " to " + (reservation.toDate == nil ? "" : (reservation.toDate)!) + "\n\n"
                }
            }
            reservationString.remove(at: reservationString.characters.index(before: reservationString.endIndex))
            self.reservationsLabel.text = reservationString
            self.reservationTextView.text = reservationDetailsString
        }else {
            self.reservationsLabel.text = ""
            self.reservationTextView.text = ""
            self.reservationTextField.text = ""
        }
        self.reservationTextField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func scanButtonAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func searchButtonAction(_ sender: AnyObject) {
        if (self.reservationTextField.text != "") {
            self.searchOrScanReservationMethod()
        }else {
            let alert = UIAlertController(title: klAlert, message: klPleaseGiveValidInputs, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchOrScanReservationMethod() {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let loadDetailsManager:GetAllReservationsBySearchParamService = GetAllReservationsBySearchParamService()
        loadDetailsManager.delegate = self
        loadDetailsManager.loadDetailsByLastNameWebService(kLoadReservationDetailsByReservationForCheckout, parameters: ["RESERVATION": reservationTextField.text!])
    }
    
    @IBAction func saveAndAddMoreReservationButtonAction
        (_ sender: AnyObject) {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            naviController?.ticketBO?.reservationsArray = self.selectedReservationArray
            Utility.sharedInstance.hideHUD()
    }
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        naviController?.ticketBO?.reservationsArray = self.selectedReservationArray
        
        //display next reservation screen with updated amount
        let checkOutStroyboardId = Utility.createStoryBoardid(kCheckOut)
        let reservationAppliedViewController = checkOutStroyboardId.instantiateViewController(withIdentifier: "ReservationAppliedViewController") as! ReservationAppliedViewController
        reservationAppliedViewController.ticketBO = naviController?.ticketBO
        naviController?.pushViewController(reservationAppliedViewController, animated: true)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        let reservtionBO = response as! ReservationAndFPCardDetailsBO
        var isAlreadyExist = false
        if self.selectedReservationArray?.count > 0 {
            
            for reservation in self.selectedReservationArray! {
                if reservation.reservationCode == reservtionBO.reservationCode {
                    isAlreadyExist = true
                    break
                }
            }
            if !isAlreadyExist {
                self.selectedReservationArray?.append(reservtionBO)
            }
        }else {
            self.selectedReservationArray?.append(reservtionBO)
        }
        
        self.reFreshView(self.selectedReservationArray)
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        Utility.sharedInstance.hideHUD()
        
        let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
