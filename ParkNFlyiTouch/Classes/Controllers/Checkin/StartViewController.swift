//
//  StartViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 01/02/16.
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


class StartViewController: BaseViewController, MultipleTicketsViewControllerDelegate {
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var preprintedTicketTextfield: TextField!
    @IBOutlet weak var heightLayoutConstraitOfSaveButton: NSLayoutConstraint!
    @IBOutlet weak var reservationTextfield: TextField!
    @IBOutlet weak var fpCardTextfield: TextField!
    
    var reservationDetails:ReservationAndFPCardDetailsBO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
            self.title = "Scan"
        }else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow) {
            self.title = "FP/RES"
        }
        self.connectionStatusUpdate((naviController?.dtdev?.connstate)!)
        
        //Keyboard Done Button
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(StartViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.fpCardTextfield.inputAccessoryView = numberToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
            self.saveButtonOutlet.isHidden = false
            self.preprintedTicketTextfield.isUserInteractionEnabled = false
            self.preprintedTicketTextfield.textColor = UIColor.ticketNumberTextColor(UIColor())()
            self.preprintedTicketTextfield.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
            
            if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
                self.preprintedTicketTextfield.text = naviController?.ticketBO?.prePrintedTicketNumber
            }else {
                self.preprintedTicketTextfield.text = naviController?.ticketBO?.barcodeNumberString
            }
            
        }else if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
            self.saveButtonOutlet.isHidden = true
            self.heightLayoutConstraitOfSaveButton.constant = 0.00
        }
        
        naviController!.dtdev!.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        naviController!.dtdev!.disconnect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        if self.scanType == ScanType.kPreprintedTicket {
        //            self.priPrintedNumber = "MIA0-000-119"
        //            self.callValidateNumberService()
        //        } else if self.scanType == ScanType.kVINNumber {
        //            self.VINNumber = "3C3CFFBR2CT105421"
        //            self.callVINService()
        //        } else if self.scanType == ScanType.kPreprintedTicketForLookup {
        //            self.priPrintedNumberForLookup = "MIA0-000-117"
        //            self.callTicketDetailsByBarcodeService()
        //        }
    }
    
    // MARK: - IPC Machine Methods
    override func scannedBarcodeData(_ barcode: String!) {
        
        //        if self.scanType == ScanType.kPreprintedTicket {
        //            self.priPrintedNumber = barcode
        //            self.callValidateNumberService()
        //        } else if self.scanType == ScanType.kVINNumber {
        //            self.VINNumber = barcode
        //            self.callVINService()
        //        } else if self.scanType == ScanType.kPreprintedTicketForLookup {
        //            self.priPrintedNumberForLookup = barcode
        //            self.callTicketDetailsByBarcodeService()
        //        }
        
        self.clearButtonAction(UIButton())
        
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
            if Utility.checkForFPCardNumberIsValid(barcode) {
                self.fpCardTextfield.text = barcode
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned loyalty number: " + barcode), logType: "Normal")
            } else if Utility.checkForPreprintedNumberIsValid(barcode) {
                self.preprintedTicketTextfield.text = barcode
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Pre-printed number: " + barcode), logType: "Normal")
            } else if Utility.checkForReservationCodeIsValid(barcode) {
                self.reservationTextfield.text = barcode
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Reservation number: " + barcode), logType: "Normal")
            } else {
                let alert = UIAlertController(title: klError, message: "Invalid Input", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
            if Utility.checkForFPCardNumberIsValid(barcode) {
                self.fpCardTextfield.text = barcode
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned FP number: " + barcode), logType: "Normal")
            }else if Utility.checkForReservationCodeIsValid(barcode) {
                self.reservationTextfield.text = barcode
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Reservation number: " + barcode), logType: "Normal")
            } else {
                let alert = UIAlertController(title: klError, message: "Invalid Input", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.searchButtonAction(UIButton())
    }
    
    override func connectionStatusUpdate(_ connectionStatus: Int32) {
        
        if self.connectionStatusLabel == nil {
            return
        }
        
        var stateMsg = ""
        
        switch connectionStatus {
            
        case 0://CONN_DISCONNECTED:
            stateMsg = "Device not ready"
        case 1://CONN_CONNECTING:
            stateMsg = "Device not ready"
        case 2://CONN_CONNECTED:
            stateMsg = "Device ready"
        default:
            stateMsg = "Device not ready"
        }
        
        self.connectionStatusLabel.attributedText = NSAttributedString(string: stateMsg, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        
        //Battery
        do {
            let batteryInfo = try naviController!.dtdev?.getBatteryInfo()
            if batteryInfo!.health <= 20 {
                let alert = UIAlertController(title: "Low Battery", message:"\(batteryInfo!.health)% battery remaining.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
        }
        //
    }
    
    // MARK: UIButton action
    @IBAction func searchButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
            if self.validateSearch() {
                
                if (self.preprintedTicketTextfield.text != "") {
                    /** search by pre-printed ticket number */
                    self.searchOrScanByReservationNumberOrByFPCardNumber(kValidateNumberService)
                    ActivityLogsManager.sharedInstance.logUserActivity(("Searched using pre-printed number: " + self.preprintedTicketTextfield.text!), logType: "Normal")
                }
                else if (self.reservationTextfield.text != "") {
                    /** search by reservation */
                    self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation)
                    ActivityLogsManager.sharedInstance.logUserActivity(("Searched using reservation number: " + self.reservationTextfield.text!), logType: "Normal")
                }
                else if (self.fpCardTextfield.text != "") {
                    
                    if self.fpCardTextfield.text?.characters.count == 4 {
                        //use kLoadMultipleFrequentParkerByFPCardNo
                        self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadMultipleFrequentParkerByFPCardNo)
                    } else {
                        /** search by fp card number */
                        self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNo)
                    }
                    ActivityLogsManager.sharedInstance.logUserActivity(("Searched using loyalty number: " + self.fpCardTextfield.text!), logType: "Normal")
                }
            } else {
                let alert = UIAlertController(title: klAlert, message: klPleaseGiveValidInputs, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
            if self.validateSearchForOnLot() {
                
                if (self.reservationTextfield.text != "") {
                    /** search by reservation */
                    self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation)
                    ActivityLogsManager.sharedInstance.logUserActivity(("Searched using reservation number: " + self.reservationTextfield.text!), logType: "Normal")
                }
                else if (self.fpCardTextfield.text != "") {
                    
                    if self.fpCardTextfield.text?.characters.count == 4 {
                        //use kLoadMultipleFrequentParkerByFPCardNo
                        self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadMultipleFrequentParkerByFPCardNo)
                    } else {
                        /** search by fp card number */
                        self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNo)
                    }
                    ActivityLogsManager.sharedInstance.logUserActivity(("Searched using loyalty number: " + self.fpCardTextfield.text!), logType: "Normal")
                }
            } else {
                let alert = UIAlertController(title: klAlert, message: klPleaseGiveValidInputs, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    func callCheckIsTicketAlreadyExistServiceAPI() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let checkIsTicketAlreadyExistServiceManager:CheckIsTicketAlreadyExistService = CheckIsTicketAlreadyExistService()
        checkIsTicketAlreadyExistServiceManager.delegate = self
        checkIsTicketAlreadyExistServiceManager.checkIsTicketAlreadyExistWebServiceForOnLot(kCheckIsTicketAlreadyExistService, parameters:["ReservationNumber":(self.reservationDetails?.reservationCode)!])

    }
    
    func addReservationInTicket() {
        
        if self.reservationDetails?.reservationCode?.characters.count > 0 && self.reservationDetails?.reservationCode != "" {
            if naviController?.ticketBO?.reservationsArray == nil {
                naviController?.ticketBO?.reservationsArray = [ReservationAndFPCardDetailsBO]()
            }
            var isAlreadyExist = false
            
            if naviController?.ticketBO?.reservationsArray?.count > 0 {
                for reservation in (naviController?.ticketBO?.reservationsArray!)! {
                    if reservation.reservationCode == self.reservationDetails?.reservationCode {
                        isAlreadyExist = true
                        break
                    }
                }
                if !isAlreadyExist {
                    naviController?.ticketBO?.reservationsArray?.append(self.reservationDetails!)
                }
            }else {
                naviController?.ticketBO?.reservationsArray?.append(self.reservationDetails!)
            }
        }
        naviController?.updateDetailsFromReservationAndFPCardDetailsBO(self.reservationDetails)
        if self.reservationDetails?.fpCardNo?.characters.count > 0 && self.reservationDetails?.fpCardNo != "" {
            naviController?.ticketBO?.fpCardNumber = self.reservationDetails?.fpCardNo
            naviController?.ticketBO?.customerProfileID = self.reservationDetails?.customerProfileID
            naviController?.ticketBO?.identifierKey = self.reservationDetails?.fpCardNo
        }
        _ = naviController?.popViewController(animated: true)
    }
    
    func saveValidReservationAndFPcard() {
        
        if self.reservationDetails?.reservationCode?.characters.count > 0 && self.reservationDetails?.reservationCode != "" {
            self.callCheckIsTicketAlreadyExistServiceAPI()
        }
        
        if self.reservationDetails?.fpCardNo?.characters.count > 0 && self.reservationDetails?.fpCardNo != "" && self.reservationDetails?.reservationCode?.characters.count == 0 && self.reservationDetails?.reservationCode == ""  {
            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(self.reservationDetails)
            naviController?.ticketBO?.fpCardNumber = self.reservationDetails?.fpCardNo
            naviController?.ticketBO?.customerProfileID = self.reservationDetails?.customerProfileID
            naviController?.ticketBO?.identifierKey = self.reservationDetails?.fpCardNo
            _ = naviController?.popViewController(animated: true)
        }

    }

    
//    @IBAction func saveButtonAction(sender: AnyObject) {
//        
//        if self.reservationDetails?.reservationCode?.characters.count > 0 && self.reservationDetails?.reservationCode != "" {
//            self.callCheckIsTicketAlreadyExistServiceAPI()
//        }
//        
//        if self.reservationDetails?.fpCardNo?.characters.count > 0 && self.reservationDetails?.fpCardNo != "" && self.reservationDetails?.reservationCode?.characters.count == 0 && self.reservationDetails?.reservationCode == ""  {
//            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(self.reservationDetails)
//            naviController?.ticketBO?.fpCardNumber = self.reservationDetails?.fpCardNo
//            naviController?.ticketBO?.customerProfileID = self.reservationDetails?.customerProfileID?.description
//            naviController?.ticketBO?.identifierKey = self.reservationDetails?.fpCardNo
//            naviController?.popViewControllerAnimated(true)
//        }
//        
//    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
            self.reservationTextfield.text = ""
            self.fpCardTextfield.text = ""
        }else {
            self.preprintedTicketTextfield.text = ""
            self.reservationTextfield.text = ""
            self.fpCardTextfield.text = ""
        }
    }
    
    // MARK: Functional Methods
    func validateSearch() -> Bool {
        
        if self.reservationTextfield.text == "" && self.fpCardTextfield.text == "" && self.preprintedTicketTextfield.text == "" {
            return false
        }
        return true
    }
    
    // MARK: Functional Methods
    func validateSearchForOnLot() -> Bool {
        
        if self.reservationTextfield.text == "" && self.fpCardTextfield.text == "" {
            return false
        }
        return true
    }
    
    /**
     This method will call different API calls for fetching details.
     :param: reservationNumber string
     :param: FPcard number string
     :param: preprinted ticket number string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func searchOrScanByReservationNumberOrByFPCardNumber(_ identifier:String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        
        switch (identifier) {
            
        case kValidateNumberService:
            
            let serviceManager: ValidateNumberService = ValidateNumberService()
            serviceManager.delegate = self
            serviceManager.validateNumberWebService(kValidateNumberService, parameters: ["PriprintedNumber": self.preprintedTicketTextfield.text!])
            
        case kLoadFrequentParkerByFPCardNoForReservation:
            
            let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
            loadFrequentParkerManager.delegate = self
            loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoForReservation, parameters: ["ReservationNumber":self.reservationTextfield.text!, "FPCardNumber":""])
            
            break
            
        case kLoadFrequentParkerByFPCardNo:
            let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
            loadFrequentParkerManager.delegate = self
            loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNo, parameters: ["ReservationNumber":"", "FPCardNumber":self.fpCardTextfield.text!])
            
            break
            
        case kLoadMultipleFrequentParkerByFPCardNo:
            
            let loadMultiplefreuentParkerByFPCardNoManager:LoadMultipleFrequnetParkerByFPCardNoService = LoadMultipleFrequnetParkerByFPCardNoService()
            loadMultiplefreuentParkerByFPCardNoManager.delegate = self
            loadMultiplefreuentParkerByFPCardNoManager.loadMultilpeFrequentParkerByFPCardNoWebService(kLoadMultipleFrequentParkerByFPCardNo, parameters: ["FPCardNumber":self.fpCardTextfield.text!])
            
        default:
            break
        }
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: update reservation details
    func getReservationDetailsFromFPCardNumber(_ identifier:String, reservationNumber: String) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
        loadFrequentParkerManager.delegate = self
        loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoForReservation, parameters: ["ReservationNumber":reservationNumber, "FPCardNumber":""])
    }
    
    func getVehicleDetails(_ vehicleDetails: VehicleDetailsBO) {
        naviController?.vehicleDetails = vehicleDetails
        _ = naviController?.popViewController(animated: true)
        
    }
    
    func getFpCardFromMultipleCards(_ object: AnyObject, identifier: String) {
        
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
            if identifier == "FPCardWithReservation" {
                naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
                naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
//                ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (naviController?.reservationDetails?.reservationCode)!), logType: "Normal")
                
                if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                    Utility.sharedInstance.showHUDWithLabel("Loading...")
                    let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                    vehicleInformationManager.delegate = self
                    vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                }else {
                    _ = naviController?.popViewController(animated: true)
                }
                //                naviController?.popViewControllerAnimated(true)
                
            } else if identifier == "FPCard" {
                if let fpCardDetails = object as? ReservationAndFPCardDetailsBO {
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                    if fpCardDetails.reservationID?.characters.count > 0 {
                        self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                    }else {
                        naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
                        naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                        //                        naviController?.popViewControllerAnimated(true)
                        if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                            Utility.sharedInstance.showHUDWithLabel("Loading...")
                            let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                            vehicleInformationManager.delegate = self
                            vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                        }else {
                            _ = naviController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
            
            if identifier == "FPCardWithReservation" {
                self.reservationDetails = object as? ReservationAndFPCardDetailsBO
//                ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (self.reservationDetails?.reservationCode)!), logType: "Normal")
                self.saveValidReservationAndFPcard()
                //                if self.reservationDetails?.fpCardNo?.characters.count > 0 {
                //                    let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                //                    vehicleInformationManager.delegate = self
                //                    vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                //                }
                
            } else if identifier == "FPCard" {
                if let fpCardDetails = object as? ReservationAndFPCardDetailsBO {
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                    if fpCardDetails.reservationID?.characters.count > 0 {
                        self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                    }else {
                        self.reservationDetails = object as? ReservationAndFPCardDetailsBO
                        self.saveValidReservationAndFPcard()
                        //                        if self.reservationDetails?.fpCardNo?.characters.count > 0 {
                        //                            let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                        //                            vehicleInformationManager.delegate = self
                        //                            vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                        //                        }
                    }
                }
            }
        }
    }
    
    // MARK: Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let multipleTicketViewController = mainStroyboard.instantiateViewController(withIdentifier: "MultipleTicketsViewController") as? MultipleTicketsViewController
        multipleTicketViewController?.delegate = self
        
        switch (identifier) {
            
        case kValidateNumberService as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            if responseDict.getStringFromDictionary(withKeys: ["ValidateNumberResponse","ValidateNumberResult","a:Result"]) as NSString == "true" {
                if responseDict.getStringFromDictionary(withKeys: ["ValidateNumberResponse","ValidateNumberResult","a:Status","a:ErrCode"]) as NSString == "0" {
                    
                    naviController?.priprintedNumber = self.preprintedTicketTextfield.text
                    naviController?.isTicketFromServer = false
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid pre-printed number : " + (naviController?.priprintedNumber!)!), logType: "Normal")
                    _ = naviController?.popViewController(animated: true)
                    
                } else {
                    
                    let alert = UIAlertController(title: klError, message:"Preprinted number is not usable", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Invalid pre-printed number : " + self.preprintedTicketTextfield.text!), logType: "Normal")
                }
            } else {
                let alert = UIAlertController(title: klError, message:"Preprinted number is not usable", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
//                ActivityLogsManager.sharedInstance.logUserActivity(("Invalid pre-printed number : " + self.preprintedTicketTextfield.text!), logType: "Normal")
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNoForReservation as String:
            
            if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
                naviController?.reservationDetails = response as? ReservationAndFPCardDetailsBO
                naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
//                ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (naviController?.reservationDetails?.reservationCode)!), logType: "Normal")
                if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                    Utility.sharedInstance.showHUDWithLabel("Loading...")
                    let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                    vehicleInformationManager.delegate = self
                    vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                }else {
                    _ = naviController?.popViewController(animated: true)
                }
                //            naviController?.popViewControllerAnimated(true)
                
            }else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow) {
                self.reservationDetails = response as? ReservationAndFPCardDetailsBO
                naviController?.isReservationSearched = true
//                ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (self.reservationDetails?.reservationCode)!), logType: "Normal")
                self.saveValidReservationAndFPcard()
                //                if self.reservationDetails?.fpCardNo?.characters.count > 0 {
                //                    let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                //                    vehicleInformationManager.delegate = self
                //                    vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                //                }
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNo as String:
            
            if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
                if response.count > 1 {
                    
                    multipleTicketViewController!.fpCardWithReservationArray = response as? [ReservationAndFPCardDetailsBO]
                    self.present(multipleTicketViewController!, animated: true, completion: nil)
                    
                } else if response.count == 1 {
                    naviController?.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                    naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (naviController?.reservationDetails?.fpCardNo)!), logType: "Normal")
                    if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                        Utility.sharedInstance.showHUDWithLabel("Loading...")
                        let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                        vehicleInformationManager.delegate = self
                        vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                    }else {
                        _ = naviController?.popViewController(animated: true)
                    }
                    
                } else {
                    let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Invalid FP card number : " + (self.fpCardTextfield.text)!), logType: "Normal")
                }
            }else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
                if response.count > 1 {
                    
                    multipleTicketViewController!.fpCardWithReservationArray = response as? [ReservationAndFPCardDetailsBO]
                    self.present(multipleTicketViewController!, animated: true, completion: nil)
                    
                } else if response.count == 1 {
                    self.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                    self.saveValidReservationAndFPcard()
                    //                    if self.reservationDetails?.fpCardNo?.characters.count > 0 {
                    //                        let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                    //                        vehicleInformationManager.delegate = self
                    //                        vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                    //                    }
                } else {
                    let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Invalid FP card number : " + (self.fpCardTextfield.text)!), logType: "Normal")
                }
            }
            
            break
            
        case kGetVehicleInfomation as String:
            
            if response.count > 1 {
                
                multipleTicketViewController!.vehicleDetailsArray = response as? [VehicleDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                
            } else if response.count == 1 {
                naviController?.vehicleDetails = response.lastObject as? VehicleDetailsBO
                _ = naviController?.popViewController(animated: true)
            } else {
                naviController?.vehicleDetails = nil
                _ = naviController?.popViewController(animated: true)
//                let alert = UIAlertController(title: klError, message:kNoVehicle, preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.Default, handler: {
//                    action in
//                    
//                    naviController?.vehicleDetails = nil
//                    naviController?.popViewControllerAnimated(true)
//                    
//                }))
//                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadMultipleFrequentParkerByFPCardNo as String:
            
            if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
                if response.count > 1 {
                    
                    multipleTicketViewController!.fpcardArray = response as? [ReservationAndFPCardDetailsBO]
                    self.present(multipleTicketViewController!, animated: true, completion: nil)
                    
                } else if response.count == 1 {
                    if let fpCardDetails:ReservationAndFPCardDetailsBO = response.lastObject as? ReservationAndFPCardDetailsBO {
//                        ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                        if fpCardDetails.reservationID?.characters.count > 0 {
                            self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                        }else {
                            naviController?.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                            Utility.sharedInstance.showHUDWithLabel("Loading...")
                            let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                            vehicleInformationManager.delegate = self
                            vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                            //                            naviController?.popViewControllerAnimated(true)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else  if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
                if response.count > 1 {
                    
                    multipleTicketViewController!.fpcardArray = response as? [ReservationAndFPCardDetailsBO]
                    self.present(multipleTicketViewController!, animated: true, completion: nil)
                    
                } else if response.count == 1 {
                    if let fpCardDetails:ReservationAndFPCardDetailsBO = response.lastObject as? ReservationAndFPCardDetailsBO {
//                        ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                        if fpCardDetails.reservationID?.characters.count > 0 {
                            self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                        }else {
                            self.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                            self.saveValidReservationAndFPcard()
                            //                            let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                            //                            vehicleInformationManager.delegate = self
                            //                            vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                        }
                    }
                } else {
                    let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            break
            
        case kCheckIsTicketAlreadyExistService as String:
            let responseDict: NSDictionary = response as! NSDictionary
            if (responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:ErrCode"]) as NSString) == "0" {
                
                self.addReservationInTicket()
                
            }else {
              
                self.reservationDetails?.reservationCode?.removeAll()
                if self.reservationDetails?.fpCardNo?.characters.count > 0 && self.reservationDetails?.fpCardNo != "" && self.reservationDetails?.reservationCode?.characters.count == 0 && self.reservationDetails?.reservationCode == ""  {
                    naviController?.ticketBO?.fpCardNumber = self.reservationDetails?.fpCardNo
                    naviController?.ticketBO?.customerProfileID = self.reservationDetails?.customerProfileID
                    naviController?.ticketBO?.identifierKey = self.reservationDetails?.fpCardNo
                    naviController?.updateDetailsFromReservationAndFPCardDetailsBO(self.reservationDetails)
                    _ = naviController?.popViewController(animated: true)
                }else {
                    
                    let messageString = responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:Message"]) as String
                    
                    let alert = UIAlertController(title: klError, message: (messageString as String), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    Utility.sharedInstance.hideHUD()
                }
            }
            break
            
        default:
            break
        }
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        switch (identifier) {
            
        case kGetVehicleInfomation as String:
            naviController?.vehicleDetails = nil
            _ = naviController?.popViewController(animated: true)
//            let alert = UIAlertController(title: klError, message:kNoVehicle, preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.Default, handler: {
//                action in
//                
//                naviController?.vehicleDetails = nil
//                naviController?.popViewControllerAnimated(true)
//            }))
//            self.presentViewController(alert, animated: true, completion: nil)
            
            break
            
        default:
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
        }
    }
}
