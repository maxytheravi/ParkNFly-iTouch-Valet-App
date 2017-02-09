//
//  LookupViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/6/15.
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


class LookupViewController: BaseViewController,MultipleTicketsViewControllerDelegate {
    
    /** UITextField outlet for reservation number textField.
     */
    @IBOutlet weak var reservationNumberTextfield: TextField!
    /** UITextField outlet for fpcard number textField.
     */
    @IBOutlet weak var fpcardTextfield: TextField!
    /** UITextField outlet for phone number textField.
     */
    @IBOutlet weak var phoneNumberTextfield: TextField!
    /** UITextField outlet for last name textField.
     */
    @IBOutlet weak var lastNameTextfield: TextField!
    
    //    @IBOutlet weak var VINTextfield: TextField!
    
    @IBOutlet weak var tagTextfield: TextField!
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    var scannedString = ""
    var cardTypeString = ""
    var isLastNameSearched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Look Up"
        
        //Keyboard Done Button
        var numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LookupViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.phoneNumberTextfield.inputAccessoryView = numberToolbar
        
        //Keyboard Done Button
        numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LookupViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.fpcardTextfield.inputAccessoryView = numberToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
            //            self.VINTextfield.isHidden = true
            self.tagTextfield.isHidden = true
        }
        
        naviController!.dtdev!.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        naviController!.dtdev!.disconnect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        self.scannedString = "fgh"
        //        self.callValidateCardTypeEncryptedNumber()
    }
    
    func popLookupViewControllerAnimated(_ flag: Bool) {
        
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
            _ = naviController?.popViewController(animated: flag)
        } else {
            for viewController in (naviController?.viewControllers)! {
                
                if viewController.isKind(of: HomeViewController.self) {
                    
                    _ = naviController?.popToViewController(viewController, animated: false)
                    
                    if (naviController?.currentFlowStatus == FlowStatus.kCheckOutFlow) {
                        (viewController as! HomeViewController).checkoutButtonAction(UIButton())
                    } else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow) {
                        (viewController as! HomeViewController).onlotButtonAction(UIButton())
                    }
                }
            }
        }
    }
    
    // MARK: - IPC Machine Methods
    override func scannedBarcodeData(_ barcode: String!) {
        self.scannedString = barcode
        
        if Utility.checkForFPCardNumberIsValid(barcode) == false && Utility.checkForReservationCodeIsValid(barcode) == false {
            let alert = UIAlertController(title: klError, message: "Invalid Input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }else {
            self.callValidateCardTypeEncryptedNumber()
            ActivityLogsManager.sharedInstance.logUserActivity(("Scanned FP/Reservation card number:" + barcode ), logType: "Normal")
        }
    }
    
    func callValidateCardTypeEncryptedNumber() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let validateDiscountCardTypeManager:ValidateCardTypeEncryptedNumberService = ValidateCardTypeEncryptedNumberService()
        validateDiscountCardTypeManager.delegate = self
        let encryptedIdentifierKey:String = Encryptor.encrypt(self.scannedString)
        validateDiscountCardTypeManager.validateCardTypeEncryptedNumberWebService(kValidateCardTypeEncryptedNumberForIdentifier, parameters: ["IdentifierKey":encryptedIdentifierKey])
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
    
    // MARK: - Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UIButton action
    @IBAction func searchButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if self.validateSearch() {
            
            naviController?.clearDataForLookup()
            
            if (self.reservationNumberTextfield.text != "") {
                /** search by reservation */
                //use kLoadFrequentParkerByFPCardNoForReservation
                self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation)
                ActivityLogsManager.sharedInstance.logUserActivity(("Searched for the reservation number: " + self.reservationNumberTextfield.text!), logType: "Normal")
                
            }
            else if (self.fpcardTextfield.text != "") {
                /**search by fpcardnumber */
                if self.fpcardTextfield.text?.characters.count < 10 {
                    //use kLoadMultipleFrequentParkerByFPCardNo
                    self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadMultipleFrequentParkerByFPCardNo)
                    
                }else {
                    if(naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
                        self.searchOrScanByReservationNumberOrByFPCardNumber(kValidateCardTypeEncryptedNumberForLookUP)
                        
                    }else {
                        //use kLoadFrequentParkerByFPCardNo
                        self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNo)
                    }
                }
                ActivityLogsManager.sharedInstance.logUserActivity(("Searched for the frequent parker number: " + self.fpcardTextfield.text!), logType: "Normal")
            }
            else if (self.phoneNumberTextfield.text != "") {
                /**search by phonenumber */
                //use kkLoadFrequentParkerByFPCardNoForPhoneNoForReservation
                self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNoByPhoneNoOfReservation)
                ActivityLogsManager.sharedInstance.logUserActivity(("Searched customer details using phone number: " + self.phoneNumberTextfield.text!), logType: "Normal")
            }
            else if(self.lastNameTextfield.text != ""){
                /**search by last name */
                // use kLoadDetailsByLastName
                self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadDetailsByLastName)
                ActivityLogsManager.sharedInstance.logUserActivity(("Searched customer details using last name: " + self.lastNameTextfield.text!), logType: "Normal")
            }
                /*else if(self.VINTextfield.text != ""){
                 /**search by last name */
                 // use kLoadTicketsByVIN
                 self.callTicketDetailsByBarcodeVIN(self.VINTextfield.text!)
                 ActivityLogsManager.sharedInstance.logUserActivity(("Searched using VIN : " + self.VINTextfield.text!), logType: "Normal")
                 }*/
            else if(self.tagTextfield.text != ""){
                /**search by last name */
                // use kLoadTicketsByTag
                self.callTicketDetailsByBarcodeTag(self.tagTextfield.text!)
                ActivityLogsManager.sharedInstance.logUserActivity(("Searched customer details using Tag: " + self.tagTextfield.text!), logType: "Normal")
            }
        } else {
            let alert = UIAlertController(title: klAlert, message: klPleaseGiveValidInputs, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    @IBAction func clearButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        self.reservationNumberTextfield.text = ""
        self.fpcardTextfield.text = ""
        self.phoneNumberTextfield.text = ""
        self.lastNameTextfield.text = ""
        //        self.VINTextfield.text = ""
        self.tagTextfield.text = ""
    }
    
    @IBAction func okButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        //        self.popLookupViewControllerAnimated(true)
        _ = naviController?.popViewController(animated: true)
    }
    
    /**
     This method will call LoadFrequentParkerByFPCardNo api.
     :param: reservationNumber string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func searchOrScanByReservationNumberOrByFPCardNumber(_ identifier:String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        
        switch (identifier) {
        case kLoadFrequentParkerByFPCardNoForReservation:
            
            if(naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
                let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
                loadFrequentParkerManager.delegate = self
                loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoForReservation, parameters: ["ReservationNumber":self.reservationNumberTextfield.text!, "FPCardNumber":""])
                
            }else {
                let getTicketServiceManager: GetTicketService = GetTicketService()
                getTicketServiceManager.delegate = self
                getTicketServiceManager.getTicketWebService(kGetTicketForReservationNo, parameters: ["ReservationNumber": self.reservationNumberTextfield.text!])
            }
            
            break
            
        case kLoadMultipleFrequentParkerByFPCardNo:
            
            if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
                let loadMultiplefreuentParkerByFPCardNoManager:LoadMultipleFrequnetParkerByFPCardNoService = LoadMultipleFrequnetParkerByFPCardNoService()
                loadMultiplefreuentParkerByFPCardNoManager.delegate = self
                loadMultiplefreuentParkerByFPCardNoManager.loadMultilpeFrequentParkerByFPCardNoWebService(kLoadMultipleFrequentParkerByFPCardNo, parameters: ["FPCardNumber":self.fpcardTextfield.text!])
                
            }else {
                let getTicketServiceManager: GetTicketService = GetTicketService()
                getTicketServiceManager.delegate = self
                getTicketServiceManager.getTicketWebService(kGetTicketForFPCardNo, parameters: ["FPCardNumber": self.fpcardTextfield.text!])
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNo:
            
            if(naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
                let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
                loadFrequentParkerManager.delegate = self
                loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNo, parameters: ["ReservationNumber":"", "FPCardNumber":self.fpcardTextfield.text!])
                
            }else {
                let getTicketServiceManager: GetTicketService = GetTicketService()
                getTicketServiceManager.delegate = self
                getTicketServiceManager.getTicketWebService(kGetTicketForFPCardNo, parameters: ["FPCardNumber": self.fpcardTextfield.text!])
            }
            
            break
            
        case kValidateCardTypeEncryptedNumberForLookUP :
            
            let validateDiscountCardTypeManager:ValidateCardTypeEncryptedNumberService = ValidateCardTypeEncryptedNumberService()
            validateDiscountCardTypeManager.delegate = self
            let encryptedIdentifierKey:String = Encryptor.encrypt(self.fpcardTextfield.text)
            validateDiscountCardTypeManager.validateCardTypeEncryptedNumberWebService(kValidateCardTypeEncryptedNumberForLookUP, parameters: ["IdentifierKey":encryptedIdentifierKey])
            
            break
            
        case kLoadFrequentParkerByFPCardNoByPhoneNoOfReservation:
            
            if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
                let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
                loadFrequentParkerManager.delegate = self
                loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoByPhoneNoOfReservation, parameters: ["PhoneNumber":self.phoneNumberTextfield.text!, "FPCardNumber":""])
                
            }else {
                let loadAllTicketsManager:GetAllTicketBySearchParamService = GetAllTicketBySearchParamService()
                loadAllTicketsManager.delegate = self
                loadAllTicketsManager.loadAllTicketsBySearchWebService(kLoadTicketsByPhoneNumber
                    , parameters: ["PhoneNumber":self.phoneNumberTextfield.text!])
            }
            
            break
            
        case kLoadDetailsByLastName:
            
            if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
                self.isLastNameSearched = true
                let loadDetailsManager:GetAllReservationsBySearchParamService = GetAllReservationsBySearchParamService()
                loadDetailsManager.delegate = self
                loadDetailsManager.loadDetailsByLastNameWebService(kLoadDetailsByLastName, parameters: ["LastName": self.lastNameTextfield.text!])
                
            }else {
                let loadAllTicketsManager:GetAllTicketBySearchParamService = GetAllTicketBySearchParamService()
                loadAllTicketsManager.delegate = self
                loadAllTicketsManager.loadAllTicketsBySearchWebService(kLoadTicketsByLastName
                    , parameters: ["LastName":self.lastNameTextfield.text!])
            }
            
            /*case kLoadTicketsByVIN:
             if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow || naviController?.currentFlowStatus == FlowStatus.kCheckOutFlow){
             let loadAllTicketsManager:GetAllTicketBySearchParamService = GetAllTicketBySearchParamService()
             loadAllTicketsManager.delegate = self
             loadAllTicketsManager.loadAllTicketsBySearchWebService(kLoadTicketsByVIN
             , parameters: ["VIN":self.VINTextfield.text!])
             }*/
            
        case kLoadTicketsByTag:
            if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow || naviController?.currentFlowStatus == FlowStatus.kCheckOutFlow){
                let loadAllTicketsManager:GetAllTicketBySearchParamService = GetAllTicketBySearchParamService()
                loadAllTicketsManager.delegate = self
                loadAllTicketsManager.loadAllTicketsBySearchWebService(kLoadTicketsByTag
                    , parameters: ["Tag":self.tagTextfield.text!])
            }
            
        default:
            break
        }
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: Functional Methods
    func validateSearch() -> Bool {
        
        if reservationNumberTextfield.text == "" && fpcardTextfield.text == "" && phoneNumberTextfield.text == "" && lastNameTextfield.text == "" && /*VINTextfield.text == "" && */tagTextfield.text == "" {
            return false
        }
        return true
    }
    
    //MARK: GetTicketByBarcode methods
    func getTicketFromMultipleTickets(_ ticketBO: TicketBO) {
//        Utility.sharedInstance.showHUDWithLabel("Loading...")
        self.getTicketDetailsByBarcode(ticketBO)
    }
    
    func getVehicleDetails(_ vehicleDetails: VehicleDetailsBO) {
        naviController?.vehicleDetails = vehicleDetails
//        ActivityLogsManager.sharedInstance.logUserActivity(("Fetched successfully the vehicle details of : " + (naviController?.vehicleDetails?.identifierKey)!), logType: "Normal")
        //        self.popLookupViewControllerAnimated(true)
        if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
            self.loadCreditCardForFP(fpCardNo)
        }
    }
    
    func getReservationDetailsFromFPCardNumber(_ identifier:String, reservationNumber: String) {
        
        if(naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
            loadFrequentParkerManager.delegate = self
            loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoForReservation, parameters: ["ReservationNumber":reservationNumber, "FPCardNumber":""])
        }
    }
    
    func getFpCardFromMultipleCards(_ object: AnyObject, identifier: String) {
        
//        Utility.sharedInstance.showHUDWithLabel("Loading...")
        if identifier == "FPCard" {
            if let fpCardDetails = object as? ReservationAndFPCardDetailsBO {
//                ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                
                if isLastNameSearched == true {
                    if fpCardDetails.reservationCode?.characters.count > 0 {
                        self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationCode!)
                    }else {
                        naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
                        naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                        
                        if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                            Utility.sharedInstance.showHUDWithLabel("Loading...")
                            let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                            vehicleInformationManager.delegate = self
                            vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                        }else {
                            self.popLookupViewControllerAnimated(true)
                        }
                        
                    }
                }else {
                    
                    if fpCardDetails.reservationID?.characters.count > 0 {
                        self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                    }else {
                        naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
                        naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                        
                        if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                            Utility.sharedInstance.showHUDWithLabel("Loading...")
                            let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                            vehicleInformationManager.delegate = self
                            vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                        }else {
                            self.popLookupViewControllerAnimated(true)
                        }
                        
                    }
                }
            }
        } else if identifier == "Reservation" {
            naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (naviController?.reservationDetails?.reservationCode)!), logType: "Normal")
            self.popLookupViewControllerAnimated(true)
            
        } else if identifier == "FPCardWithReservation" {
            naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
            naviController?.contractCardDetails = nil
            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (naviController?.reservationDetails?.fpCode)!), logType: "Normal")
            
            if naviController?.reservationDetails?.reservationCode?.characters.count > 0 {
                self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: (naviController?.reservationDetails?.reservationCode)!)
            }else {
                self.popLookupViewControllerAnimated(true)
            }
        }
        
    }
    
    func getTicketDetailsByBarcode(_ ticketBO: TicketBO) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getTicketByBarcodeServiceManager: GetTicketByBarcodeService = GetTicketByBarcodeService()
        getTicketByBarcodeServiceManager.delegate  = self
        getTicketByBarcodeServiceManager.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["TicketNumber": ticketBO.barcodeNumberString!])
//        ActivityLogsManager.sharedInstance.logUserActivity(("Searched the ticket number is : " + ticketBO.barcodeNumberString!), logType: "Normal")
    }
    
    func callTicketDetailsByBarcodeVIN(_ VIN: String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getTicketByBarcodeService: GetTicketByBarcodeService = GetTicketByBarcodeService()
        getTicketByBarcodeService.delegate  = self
        getTicketByBarcodeService.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["VIN": VIN])
    }
    
    func callTicketDetailsByBarcodeTag(_ tag: String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getTicketByBarcodeService: GetTicketByBarcodeService = GetTicketByBarcodeService()
        getTicketByBarcodeService.delegate  = self
        getTicketByBarcodeService.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["Tag": tag])
    }
    
    func loadCreditCardForFP(_ fpCardNumber: String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let creditCardInfoManager:GetCreditCardAssociatedWithFPService = GetCreditCardAssociatedWithFPService()
        creditCardInfoManager.delegate = self
        creditCardInfoManager.getCreditCardAssociatedWithFPNoWebService(kGetCreditCardAssociatedWithFP, parameters:["FPCardNumber": fpCardNumber])
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        Utility.sharedInstance.hideHUD()
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let multipleTicketViewController = mainStroyboard.instantiateViewController(withIdentifier: "MultipleTicketsViewController") as? MultipleTicketsViewController
        multipleTicketViewController?.delegate = self
        
        switch (identifier) {
            
        case kValidateCardTypeEncryptedNumberForIdentifier as String:
            
            let cardTypeResponseDict: NSDictionary = response as! NSDictionary
            
            if let cardTypeDict: NSDictionary = cardTypeResponseDict.getObjectFromDictionary(withKeys: ["ValidateCardTypeEncryptedNumberResponse"]) as? NSDictionary {
                if let cardType = cardTypeDict.getInnerText(forKey: "ValidateCardTypeEncryptedNumberResult") {
                    self.cardTypeString = cardType
                }
            }
            
//            ActivityLogsManager.sharedInstance.logUserActivity(("CardType of searched card is : " + cardTypeString), logType: "Normal")
            self.clearButtonAction(UIButton())
            
            if cardTypeString == "ReservationNumber" {
                self.reservationNumberTextfield.text = self.scannedString
            } else {
                self.fpcardTextfield.text = self.scannedString
            }
            
            self.searchButtonAction(UIButton())
            
            break
            
        case kValidateCardTypeEncryptedNumberForLookUP as String:
            
            let cardTypeResponseDict: NSDictionary = response as! NSDictionary
            
            if let cardTypeDict: NSDictionary = cardTypeResponseDict.getObjectFromDictionary(withKeys: ["ValidateCardTypeEncryptedNumberResponse"]) as? NSDictionary {
                if let cardType = cardTypeDict.getInnerText(forKey: "ValidateCardTypeEncryptedNumberResult") {
                    self.cardTypeString = cardType
                }
            }
            
//            ActivityLogsManager.sharedInstance.logUserActivity(("CardType of searched card is : " + cardTypeString), logType: "Normal")
            
            if self.cardTypeString == "VIP" || cardTypeString == "Employee" || cardTypeString == "ContractCard" {
                
                Utility.sharedInstance.showHUDWithLabel("Loading...")
                let loadVIPManager:GetContractCardService = GetContractCardService()
                loadVIPManager.delegate = self
                loadVIPManager.getContractCardWebService(kGetContractCard, parameters:["CONTRACTCARDNUMBER" : self.fpcardTextfield.text!])
                
            } else {
                
                Utility.sharedInstance.showHUDWithLabel("Loading...")
                let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
                loadFrequentParkerManager.delegate = self
                loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNo, parameters: ["ReservationNumber":"", "FPCardNumber":self.fpcardTextfield.text!])
            }
            
            break
            
        case kGetContractCard as String:
            
            naviController?.contractCardDetails = response as? ContractCardInfoBO
            if naviController?.contractCardDetails?.cardNumber?.characters.count > 0 && naviController?.contractCardDetails?.cardNumber != nil {
                naviController?.reservationDetails?.fpCode = nil
                self.popLookupViewControllerAnimated(true)
                
            }else {
                
                let alert = UIAlertController(title: klError, message:"Invalid VIP number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                    self.fpcardTextfield.text = ""
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNoForReservation as String:
            
            naviController?.reservationDetails = response as? ReservationAndFPCardDetailsBO
            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (naviController?.reservationDetails?.reservationCode)!), logType: "Normal")
            if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                Utility.sharedInstance.showHUDWithLabel("Loading...")
                naviController?.contractCardDetails = nil
                let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                vehicleInformationManager.delegate = self
                vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
            }else {
                self.popLookupViewControllerAnimated(true)
            }
            
            break
            
        case kGetVehicleInfomation as String:
            
            if response.count > 1 {
                multipleTicketViewController!.vehicleDetailsArray = response as? [VehicleDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                
            } else if response.count == 1 {
                naviController?.vehicleDetails = response.lastObject as? VehicleDetailsBO
//                ActivityLogsManager.sharedInstance.logUserActivity(("Fetched successfully the vehicle details of : " + (naviController?.vehicleDetails?.identifierKey)!), logType: "Normal")
                //                self.popLookupViewControllerAnimated(true)
                if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                    self.loadCreditCardForFP(fpCardNo)
                }
            } else {
                naviController?.vehicleDetails = nil
                //                self.popLookupViewControllerAnimated(true)
                if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                    self.loadCreditCardForFP(fpCardNo)
                }
                //                let alert = UIAlertController(title: klError, message:kNoVehicle, preferredStyle: UIAlertControllerStyle.Alert)
                //                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.Default, handler: {
                //                    action in
                //
                //                    naviController?.vehicleDetails = nil
                //                    self.popLookupViewControllerAnimated(true)
                //
                //                }))
                //                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadMultipleFrequentParkerByFPCardNo as String:
            
            if response.count > 1 {
                multipleTicketViewController!.fpcardArray = response as? [ReservationAndFPCardDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if response.count == 1 {
                if let fpCardDetails:ReservationAndFPCardDetailsBO = response.lastObject as? ReservationAndFPCardDetailsBO {
                    if fpCardDetails.reservationID?.characters.count > 0 {
                        self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                    }else {
                        naviController?.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                        naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                        Utility.sharedInstance.showHUDWithLabel("Loading...")
                        let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                        vehicleInformationManager.delegate = self
                        vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                    }
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                    naviController?.contractCardDetails = nil
                    
                }
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNo as String:
            
            if response.count > 1 {
                multipleTicketViewController!.fpCardWithReservationArray = response as? [ReservationAndFPCardDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if response.count == 1 {
                if let fpCardDetails:ReservationAndFPCardDetailsBO = response.lastObject as? ReservationAndFPCardDetailsBO {
                    if fpCardDetails.reservationCode?.characters.count > 0 {
                        self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationCode!)
                    }else {
                        naviController?.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                        naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                        Utility.sharedInstance.showHUDWithLabel("Loading...")
                        let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                        vehicleInformationManager.delegate = self
                        vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                    }
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                    naviController?.contractCardDetails = nil
                }
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadDetailsByLastName as String:
            
            if response.count > 1 {
                multipleTicketViewController!.fpcardArray = response as? [ReservationAndFPCardDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if response.count == 1 {
                naviController?.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 && naviController?.reservationDetails?.fpCardNo != nil {
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Fetched successfully customer details using last name, the last name is : " + (naviController?.reservationDetails?.lastName)!), logType: "Normal")
                }
                self.popLookupViewControllerAnimated(true)
                
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNoByPhoneNoOfReservation as String:
            
            if response.count > 1 {
                multipleTicketViewController!.reservationArray = response as? [ReservationAndFPCardDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if response.count == 1 {
                naviController?.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                if naviController?.reservationDetails?.reservationCode?.characters.count > 0 && naviController?.reservationDetails?.reservationCode != nil {
                    self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: (naviController?.reservationDetails?.reservationCode)!)
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (naviController?.reservationDetails?.reservationCode)!), logType: "Normal")
                }
//                ActivityLogsManager.sharedInstance.logUserActivity(("Fetched successfully customer details using phone number, the phone number is : " + (naviController?.reservationDetails?.phoneNumber?.description)!), logType: "Normal")
                
                self.popLookupViewControllerAnimated(true)
                
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kGetTicketForFPCardNo as String:
            
            let barcodeNumberArray:[TicketBO]? = response as? [TicketBO]
            
            if barcodeNumberArray!.count > 1 {
                multipleTicketViewController!.ticketsArray = barcodeNumberArray
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if barcodeNumberArray!.count == 1 {
                self.getTicketDetailsByBarcode((barcodeNumberArray?.first)!)
                return
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kGetTicketForReservationNo as String:
            
            let barcodeNumberArray:[TicketBO]? = response as? [TicketBO]
            
            if barcodeNumberArray!.count > 1 {
                multipleTicketViewController!.ticketsArray = barcodeNumberArray
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if barcodeNumberArray!.count == 1 {
                self.getTicketDetailsByBarcode((barcodeNumberArray?.first)!)
                return
                
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadTicketsByPhoneNumber as String:
            
            let barcodeNumberArray:[TicketBO]? = response as? [TicketBO]
            
            if barcodeNumberArray!.count > 1 {
                multipleTicketViewController!.ticketsArray = barcodeNumberArray
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if barcodeNumberArray!.count == 1 {
                self.getTicketDetailsByBarcode((barcodeNumberArray?.first)!)
                return
                
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadTicketsByLastName as String:
            
            let barcodeNumberArray:[TicketBO]? = response as? [TicketBO]
            
            if barcodeNumberArray!.count > 1 {
                multipleTicketViewController!.ticketsArray = barcodeNumberArray
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                //                self.navigationController?.pushViewController(multipleTicketViewController!, animated: true)
                
            } else if barcodeNumberArray!.count == 1 {
                self.getTicketDetailsByBarcode((barcodeNumberArray?.first)!)
                return
                
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kGetTicketByBarcode as String:
            
            naviController?.ticketBO = response as? TicketBO
            naviController?.updateDetailsFromTicketBO(naviController?.ticketBO)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Valid ticket number : " + (naviController?.ticketBO?.barcodeNumberString)!), logType: "Normal")
            self.popLookupViewControllerAnimated(true)
            
            break
            
        case kLoadFrequentParkerByFPCardNoByPhoneNoOfFpCard as String:
            
            naviController?.reservationDetails = response as? ReservationAndFPCardDetailsBO
            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Fetched successfully customer details using phone number, the phone number is : " + (naviController?.reservationDetails?.phoneNumber?.description)!), logType: "Normal")
            self.popLookupViewControllerAnimated(true)
            break
            
        case kGetCreditCardAssociatedWithFP as String:
            
            let creditCardInfo = response as? CreditCardInfoBO
            
            if let _ = creditCardInfo, let _ = creditCardInfo?.cardNumber, creditCardInfo?.cardNumber?.characters.count > 0 {
                
                let alert = UIAlertController(title: klMessage, message:"Do you want to link credit card number '\((creditCardInfo?.maskedCardNumber)!)'?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                    self.popLookupViewControllerAnimated(true)
                }))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    naviController?.creditCardInfo = creditCardInfo
                    self.popLookupViewControllerAnimated(true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        default:
            break
        }
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        switch (identifier) {
            
        case kGetVehicleInfomation as String:
            naviController?.vehicleDetails = nil
            if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                self.loadCreditCardForFP(fpCardNo)
            }
            //            self.popLookupViewControllerAnimated(true)
            //            let alert = UIAlertController(title: klError, message:kNoVehicle, preferredStyle: UIAlertControllerStyle.Alert)
            //            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.Default, handler: {
            //                action in
            //
            //                naviController?.vehicleDetails = nil
            //                self.popLookupViewControllerAnimated(true)
            //
            //            }))
            //            self.presentViewController(alert, animated: true, completion: nil)
            
            break
            
        case kGetCreditCardAssociatedWithFP as String:
            self.popLookupViewControllerAnimated(true)
            break
            
        default:
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneNumberTextfield {
            
            if textField.text?.characters.count > 10 && range.length == 0{
                return false
            }
        }
        return true
    }
}
