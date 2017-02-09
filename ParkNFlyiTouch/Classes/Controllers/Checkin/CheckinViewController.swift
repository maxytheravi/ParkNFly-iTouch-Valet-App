//
//  CheckinViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 9/28/15.
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


class CheckinViewController: BaseViewController, ActionsheetManagerDelegate, CalendarDelegate, TimepickerDelegate, UITextFieldDelegate, MultipleTicketsViewControllerDelegate {
    
    /** UITextField outlet for name textField.
     */
    @IBOutlet weak var nameTextfield: TextField!
    /** UITextField outlet for parkingType textField.
     */
    @IBOutlet weak var parkingTypetextfield: TextField!
    /** UITextField outlet for returnDate textField.
     */
    @IBOutlet weak var returnDateTextfield: TextField!
    /** UITextField outlet for returntime textField.
     */
    @IBOutlet weak var returnTimeTextfield: TextField!
    
    //    @IBOutlet weak var preprintedTicketLabel: UILabel!
    //    @IBOutlet weak var preprintedTicketTitleLabel: UILabel!
    @IBOutlet weak var preprintedTicketTextField: TextField!
    @IBOutlet weak var laxBarcodeTextField: TextField!
    @IBOutlet weak var reservationNumberTextField: TextField!
    @IBOutlet weak var fpcardTextfield: TextField!
    @IBOutlet weak var phoneNumberTextField: TextField!
    weak var currentEditedTextField: TextField?
    
    @IBOutlet weak var serviceIconImageView: UIImageView!
    @IBOutlet weak var fpCardIconImageView: UIImageView!
    @IBOutlet weak var reservationIconImageView: UIImageView!
    @IBOutlet weak var creditCardIconImageView: UIImageView!
    
    @IBOutlet weak var addTicketButton: UIButton!
    @IBOutlet weak var saveExitButton: UIButton!
    
    var calendarViewController: CalendarViewController?
    var timepickerViewController: TimepickerViewController?
    var vehicleID: String = ""
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    @IBOutlet weak var heightTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topPrePrintedTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var topButtonViewConstraint: NSLayoutConstraint!
    
    var ticketBO: TicketBO?
    
    var scannedBarcodeRes = ""
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Check In"
        
        //Keyboard Done Button
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CheckinViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.phoneNumberTextField.inputAccessoryView = numberToolbar
        
        self.connectionStatusUpdate((naviController?.dtdev?.connstate)!)
        
//        self.scannedBarcodeData("CRP0-000-075")
//        self.scannedBarcodeData("RVK818")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTextFieldsWithRequiredData()
        
        if !Utility.isLax() {
            self.laxBarcodeTextField.isHidden = true
            self.heightTextViewConstraint.constant = 244
            self.bottomTextViewConstraint.constant = -70
            self.topPrePrintedTextConstraint.constant = 0
            self.topButtonViewConstraint.constant = 90
            self.view.layoutIfNeeded()
        } else {
            self.laxBarcodeTextField.isHidden = false
            self.heightTextViewConstraint.constant = 279
            self.bottomTextViewConstraint.constant = -90
            self.topPrePrintedTextConstraint.constant = 35
            self.topButtonViewConstraint.constant = 100
            self.view.layoutIfNeeded()
        }
        
//        naviController?.magneticCardData("%B4111111111111111^RAUI KARAFBHAJNE          ^2002206136040000000000504000001?", track2: ";4111111111111111=20022061360450400001?", track3: "")
        
        //Add observer for Keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateTicketContentViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateTicketContentViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        naviController!.dtdev!.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Add observer for Keyboard notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        naviController!.dtdev!.disconnect()
    }
    
    
    override func popingViewController() {
        naviController!.clearDataOnAppFlowChanged()
    }
    
    func updateTextFieldsWithRequiredData() {
        
        if naviController?.updatedFirstName?.characters.count > 0 && naviController?.updatedLastName?.characters.count > 0 {
            self.nameTextfield.text = (naviController?.updatedFirstName)! + " " + (naviController?.updatedLastName)!
        } else if naviController?.updatedFirstName?.characters.count > 0 && naviController?.updatedLastName?.characters.count == 0 {
            self.nameTextfield.text = (naviController?.updatedFirstName)!
        }else if naviController?.contractCardDetails?.cardOwnerName?.characters.count > 0 && naviController?.contractCardDetails?.cardOwnerName != nil {
            self.nameTextfield.text = naviController?.contractCardDetails?.cardOwnerName
        }else {
            self.nameTextfield.text = ""
        }
        
        self.parkingTypetextfield.text = naviController?.updatedParkingTypeName
        
        if naviController?.updatedDate != nil && naviController?.updatedDate != "" {
            self.returnDateTextfield.text = "RTN: " + Utility.dateStringFromString((naviController?.updatedDate)!, dateFormat: "yyyy-MM-dd", conversionDateFormat: Utility.getDisplyDateFormat())!
        } else {
            self.returnDateTextfield.text = ""
        }
        
        if naviController?.updatedTime != nil && naviController?.updatedTime != "" {
            self.returnTimeTextfield.text = Utility.dateStringFromString((naviController?.updatedTime)!, dateFormat: "HH:mm:ss", conversionDateFormat: Utility.getDisplyTimeFormat())
        } else {
            self.returnTimeTextfield.text = ""
        }
        
        if naviController!.priprintedNumber != nil && naviController!.priprintedNumber != "" {
            self.preprintedTicketTextField.text = naviController!.priprintedNumber
        } else {
            self.preprintedTicketTextField.text = ""
        }
        
        if self.ticketBO != nil && self.ticketBO?.barcodeNumberString != nil && self.ticketBO?.barcodeNumberString != "" {
            self.laxBarcodeTextField.text = self.ticketBO?.barcodeNumberString
        } else {
            self.laxBarcodeTextField.text = ""
        }
        
        if naviController!.reservationDetails != nil && naviController!.reservationDetails?.reservationCode != nil && naviController!.reservationDetails?.reservationCode != "" {
            self.reservationNumberTextField.text = "Res#: " + (naviController!.reservationDetails?.reservationCode)!
            self.reservationIconImageView.isHidden = false
        } else {
            self.reservationNumberTextField.text = ""
            self.reservationIconImageView.isHidden = true
        }
        
        if naviController!.reservationDetails != nil && naviController!.reservationDetails?.fpCardNo != nil && naviController!.reservationDetails?.fpCardNo != "" {
            self.fpcardTextfield.text = "FP#: " + (naviController!.reservationDetails?.fpCardNo)!
        } else if naviController?.contractCardDetails?.cardNumber?.characters.count > 0 && naviController?.contractCardDetails?.cardNumber != nil {
            self.fpcardTextfield.text = "VIP#: " + (naviController?.contractCardDetails?.cardNumber)!
        }else {
            self.fpcardTextfield.text = ""
        }
        
        if naviController!.reservationDetails != nil && naviController!.reservationDetails?.fpCardNo != nil && naviController!.reservationDetails?.fpCardNo != "" {
            self.fpCardIconImageView.isHidden = false
        } else {
            self.fpCardIconImageView.isHidden = true
        }
        
        if naviController!.phoneNumber != nil && naviController!.phoneNumber != "" {
            self.phoneNumberTextField.text = "\((naviController!.phoneNumber)!)"
        } else if naviController?.contractCardDetails?.cardPhoneNumber?.characters.count > 0 && naviController?.contractCardDetails?.cardPhoneNumber != nil {
            self.phoneNumberTextField.text = naviController?.contractCardDetails?.cardPhoneNumber
        }else {
            self.phoneNumberTextField.text = ""
        }
        
        if naviController!.servicesArray != nil && naviController!.servicesArray?.count > 0 {
            self.serviceIconImageView.isHidden = false
        } else {
            self.serviceIconImageView.isHidden = true
        }
        
        if let _ = naviController?.creditCardInfo, let _ = naviController?.creditCardInfo?.cardNumber, naviController?.creditCardInfo?.cardNumber?.characters.count > 0 {
            self.creditCardIconImageView.isHidden = false
        } else {
            self.creditCardIconImageView.isHidden = true
        }
        
        if Utility.isLax() {
            if (naviController!.priprintedNumber != nil && naviController!.priprintedNumber != "") || self.ticketBO != nil {
                self.addTicketButton.backgroundColor = UIColor.darkGray
                self.addTicketButton.isEnabled = false
            } else {
                self.addTicketButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
                self.addTicketButton.isEnabled = true
            }
        } else {
            if (naviController!.priprintedNumber != nil && naviController!.priprintedNumber != "") {
                self.addTicketButton.backgroundColor = UIColor.darkGray
                self.addTicketButton.isEnabled = false
            } else {
                self.addTicketButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
                self.addTicketButton.isEnabled = true
            }
        }
        
        if Utility.isLax() {
            if self.validateUpdateTicket() {
                self.saveExitButton.backgroundColor = UIColor.green
                self.saveExitButton.isEnabled = true
            } else if self.validateGenerateTicket() {
                self.saveExitButton.backgroundColor = UIColor.green
                self.saveExitButton.isEnabled = true
            } else {
                self.saveExitButton.backgroundColor = UIColor.darkGray
                self.saveExitButton.isEnabled = false
            }
        } else {
            if self.validateGenerateTicket() {
                self.saveExitButton.backgroundColor = UIColor.green
                self.saveExitButton.isEnabled = true
            } else {
                self.saveExitButton.backgroundColor = UIColor.darkGray
                self.saveExitButton.isEnabled = false
            }
        }
        
        if self.preprintedTicketTextField.text?.characters.count > 0 && self.parkingTypetextfield.text?.characters.count == 0 {
            self.parkingTypetextfield.layer.borderColor = UIColor.projectThemeRedColor(UIColor())().cgColor
            self.parkingTypetextfield.layer.borderWidth = 1.0
        } else {
            self.parkingTypetextfield.layer.borderColor = UIColor.clear.cgColor
            self.parkingTypetextfield.layer.borderWidth = 0.0
        }
        
        //        if let _ = naviController?.updatedDate {
        //            self.returnDateTextfield.text = Utility.getCurrentTimeZoneFromUTC((naviController?.updatedDate)!, dateFormat: "yyyy-MM-dd")
        //        }
        //
        //        if let _ = naviController?.updatedTime {
        //            self.returnTimeTextfield.text = Utility.getCurrentTimeZoneFromUTC((naviController?.updatedTime)!, dateFormat: "HH:mm:ss")
        //        }
    }
    
    func validateVINNumber (_ VINNumber: String!) -> String {
        var VINNumberLocal = VINNumber
        if (VINNumberLocal?.characters.count)! > 17 {
            let index = VINNumberLocal?.index((VINNumberLocal?.startIndex)!, offsetBy: 0)
            if VINNumberLocal?[index!] == "I" || VINNumberLocal?[index!] == "i" {
                VINNumberLocal = VINNumberLocal?.substring(with: Range<String.Index>((VINNumberLocal?.index((VINNumberLocal?.startIndex)!, offsetBy: 1))! ..< (VINNumberLocal?.index((VINNumberLocal?.endIndex)!, offsetBy: 0))!))
            }
        }
        
        return VINNumber
    }
    
    // MARK: UIButton action
    /**
     This method will show UIAlertController for select parking type
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    @IBAction func parkingtypeButtonAction(_ sender: AnyObject) {
        //display parking type options popover
        self.view.endEditing(true)
        
        if let _ = naviController?.productArray {
            let actionsheetView = ActionsheetObject()
            actionsheetView.delegate = self
            actionsheetView.createActionsheet((naviController?.productArray)!, identifier: kParkingTypeActionSheet)
            ActivityLogsManager.sharedInstance.logUserActivity(("Parking type button is tapped"), logType: "Normal")
        } else {
            let alert = UIAlertController(title: klError, message: "No parking type found", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    @IBAction func returndateButtonAction(_ sender: AnyObject) {
        //display calender
        self.view.endEditing(true)
        createCalendar()
    }
    
    @IBAction func returntimeButtonAction(_ sender: AnyObject) {
        //display timepicker
        self.view.endEditing(true)
        createTimepicker()
    }
    
    @IBAction func scanButtonAction(_ sender: AnyObject) {
        //        let mainStroyboardId = Utility.createStoryBoardid(kMain)
        //        let scanViewController = mainStroyboardId.instantiateViewControllerWithIdentifier("ScanViewController") as! ScanViewController
        //        scanViewController.scanType = ScanType.kPreprintedTicket
        //        naviController?.pushViewController(scanViewController, animated: true)
        
        let mainStroyboardId = Utility.createStoryBoardid(kMain)
        let startViewController = mainStroyboardId.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
        naviController?.pushViewController(startViewController, animated: true)
    }
    
    @IBAction func lookupButtonAction(_ sender: AnyObject) {
        
//        naviController!.dtdev!.disconnect()
        //push
        let mainStroyboardId = Utility.createStoryBoardid(kMain)
        let lookupViewController = mainStroyboardId.instantiateViewController(withIdentifier: "LookupViewController") as! LookupViewController
        naviController?.pushViewController(lookupViewController, animated: true)
        ActivityLogsManager.sharedInstance.logUserActivity(("Look up button is tapped"), logType: "Normal")
    }
    
    @IBAction func vehicleButtonAction(_ sender: AnyObject) {
        
//        naviController!.dtdev!.disconnect()
        //push
        let mainStroyboardId = Utility.createStoryBoardid(kMain)
        let lookupViewController = mainStroyboardId.instantiateViewController(withIdentifier: "VehicleViewController") as! VehicleViewController
        naviController?.pushViewController(lookupViewController, animated: true)
        ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle button is tapped"), logType: "Normal")
    }
    
    @IBAction func damageButtonAction(_ sender: AnyObject) {
        
        if naviController?.vehicleDetails != nil {
            let mainStroyboard = Utility.createStoryBoardid(kMain)
            let damageMarksViewController = mainStroyboard.instantiateViewController(withIdentifier: "DamageMarksViewController") as? DamageMarksViewController
            damageMarksViewController?.damageMarksArray = naviController?.vehicleDetails?.damageMarksArray
            naviController?.pushViewController(damageMarksViewController!, animated: true)
            ActivityLogsManager.sharedInstance.logUserActivity(("Damage button is tapped"), logType: "Normal")
        } else {
            let alert = UIAlertController(title: klError, message: "Please load vehicle", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func temp() -> [DamageMarkBO] {
        
        var damageMarksArray = [DamageMarkBO]()
        
        var damageMarkBO = DamageMarkBO()
        damageMarkBO.locationX = 100
        damageMarkBO.locationY = 100
        damageMarkBO.markedBy = naviController!.userName
        damageMarkBO.logDate = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())
        damageMarkBO.note = "weqwe"
        damageMarkBO.status = true
        damageMarkBO.damageID = "26"
        damageMarksArray.append(damageMarkBO)
        
        damageMarkBO = DamageMarkBO()
        damageMarkBO.locationX = 100
        damageMarkBO.locationY = 200
        damageMarkBO.markedBy = naviController!.userName
        damageMarkBO.logDate = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())
        damageMarkBO.note = "dsfadf"
        damageMarkBO.status = true
        damageMarkBO.damageID = "25"
        damageMarksArray.append(damageMarkBO)
        
        damageMarkBO = DamageMarkBO()
        damageMarkBO.locationX = 100
        damageMarkBO.locationY = 300
        damageMarkBO.markedBy = naviController!.userName
        damageMarkBO.logDate = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())
        damageMarkBO.note = "cxvzxcv"
        damageMarkBO.status = true
        damageMarkBO.damageID = "27"
        damageMarksArray.append(damageMarkBO)
        
        return damageMarksArray
    }
    
    @IBAction func serviceButtonAction(_ sender: AnyObject) {
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let serviceViewController = mainStroyboard.instantiateViewController(withIdentifier: "ServicesViewController") as? ServicesViewController
        naviController?.pushViewController(serviceViewController!, animated: true)
        
        ActivityLogsManager.sharedInstance.logUserActivity(("Service button is tapped"), logType: "Normal")
        
//        self.scannedBarcodeData("CRP0-000-075")
//        self.scannedBarcodeData("MRS805")
    }
    
    @IBAction func addTicketButtonAction(_ sender: AnyObject) {
        
//        naviController!.dtdev!.disconnect()
    }
    
    @IBAction func saveandexitButtonAction(_ sender: AnyObject) {
        
        if (naviController?.reservationDetails?.fpCode?.characters.count > 0 || naviController?.reservationDetails?.fpCardNo?.characters.count > 0) && naviController?.vehicleDetails != nil {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let addUpdateVehicleManager:AddUpdateVehicleService = AddUpdateVehicleService()
            addUpdateVehicleManager.delegate = self
            addUpdateVehicleManager.addUpdateVehicleWebService(kAddUpdateVehicle, parameters: NSDictionary())
        }else {
            self.callGenerateTicketForTablet()
        }
        
        ActivityLogsManager.sharedInstance.logUserActivity(("Save and Exit button is tapped"), logType: "Normal")
    }
    
    func validateGenerateTicket() -> Bool {
        
        if naviController?.priprintedNumber != nil && naviController?.priprintedNumber?.characters.count > 0 &&
            naviController!.updatedParkingTypeID > 0 /* &&
             (( naviController!.vehicleDetails?.licenseNumber != nil && naviController?.vehicleDetails?.licenseNumber?.characters.count > 0) ||
             (naviController?.vehicleDetails?.vehicleMake != nil && naviController?.vehicleDetails?.vehicleMake?.characters.count > 0) ||
             (naviController?.vehicleDetails?.vehicleModel != nil && naviController?.vehicleDetails?.vehicleModel?.characters.count > 0) ||
             (naviController?.vehicleDetails?.vehicleVIN != nil && naviController?.vehicleDetails?.vehicleVIN?.characters.count > 0))*/
            /* && naviController?.updatedDate != nil && naviController?.updatedDate?.characters.count > 0 && naviController?.updatedTime != nil && naviController?.updatedTime?.characters.count > 0*/ {
                return true
        }
        
        return false
    }
    
    func validateUpdateTicket() -> Bool {
        
        if naviController!.updatedParkingTypeID > 0 && self.ticketBO != nil && naviController?.priprintedNumber != nil && naviController?.priprintedNumber?.characters.count > 0 {
            return true
        }
        
        return false
    }
    
    func callAddUpdateTicketForTablet() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let addTicketUpdateValetInfoForTabletService:AddTicketUpdateValetInfoForTabletService = AddTicketUpdateValetInfoForTabletService()
        addTicketUpdateValetInfoForTabletService.delegate = self
        addTicketUpdateValetInfoForTabletService.addTicketUpdateValetInfoForTabletWebService(kAddTicketUpdateValetInfoForTabletService, parameters:["VEHICLEID": self.vehicleID])
    }
    
    func callUpdateVehicleInfoAPI() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let updateVehicleInfoService: UpdateVehicleInfoService = UpdateVehicleInfoService()
        updateVehicleInfoService.delegate = self
        updateVehicleInfoService.updateVehicleInfoService(kUpdateVehicleInfoService, parameters: ["VehicleDetailsBO":(naviController?.vehicleDetails)!, "TicketID":(naviController?.ticketFromServerTicketID)!])
    }
    
    func callCheckIsTicketAlreadyExistServiceAPI() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let checkIsTicketAlreadyExistServiceManager:CheckIsTicketAlreadyExistService = CheckIsTicketAlreadyExistService()
        checkIsTicketAlreadyExistServiceManager.delegate = self
        checkIsTicketAlreadyExistServiceManager.checkIsTicketAlreadyExistWebService(kCheckIsTicketAlreadyExistService, parameters:NSDictionary())
    }
    
    func callTicketDetailsByBarcodeService(_ barcode: String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getTicketByBarcodeService: GetTicketByBarcodeService = GetTicketByBarcodeService()
        getTicketByBarcodeService.delegate  = self
        getTicketByBarcodeService.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["TicketNumber": barcode])
    }
    
    func callGenerateTicketForTablet() {
        /*if naviController?.isTicketFromServer == true && self.validateGenerateTicket() {
         
         if naviController?.reservationDetails?.fpCode?.characters.count > 0 || naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
         
         self.callCheckIsTicketAlreadyExistServiceAPI()
         
         }else if naviController?.reservationDetails?.reservationCode?.characters.count > 0 || naviController?.reservationDetails?.reservationID?.characters.count > 0 {
         
         self.callCheckIsTicketAlreadyExistServiceAPI()
         
         }else {
         self.callAddUpdateTicketForTablet()
         }
         
         } else */
        
        if self.validateUpdateTicket() {
            
            self.callUpdateTicketForTablet()
            
        } else if self.validateGenerateTicket() {
            
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let generateTicketManager:GenerateTicketForTabletService = GenerateTicketForTabletService()
            generateTicketManager.delegate = self
            generateTicketManager.generateTicketForTabletService(kGenerateTicketForTablet, parameters:["VEHICLEID": self.vehicleID])
            
         } else {
            
            let alert = UIAlertController(title: klError, message: "Please fill data completely", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func callUpdateTicketForTablet() {
        
        self.ticketBO?.firstName = naviController?.updatedFirstName
        self.ticketBO?.lastName = naviController?.updatedLastName
        self.ticketBO?.parkingTypeName = naviController?.updatedParkingTypeName
        self.ticketBO?.parkingType = "\((naviController?.updatedParkingTypeID)!)"
        self.ticketBO?.toDateValetScan = (naviController?.updatedDate)! + (naviController?.updatedTime)!
        
        self.ticketBO?.phoneNo = naviController?.phoneNumber
        
        //Vehicle and its Damages
        self.ticketBO?.vehicleDetails = naviController?.vehicleDetails
        self.ticketBO?.vehicleDetails?.isOversized = (naviController?.isOversizeVehicle)!
        
        //Services
        if let _ = naviController?.servicesArray {
            self.ticketBO?.services = NSMutableArray(array: (naviController?.servicesArray)!)
        }
        
        //Reservation and FP
        if let _ = naviController?.reservationDetails {
            self.ticketBO?.reservationsArray = [(naviController?.reservationDetails)!]
        }
        
        if let _ = naviController?.reservationDetails?.fpCardNo {
            self.ticketBO?.fpCardNumber = naviController?.reservationDetails?.fpCardNo
            self.ticketBO?.identifierKey = naviController?.reservationDetails?.fpCardNo
            self.ticketBO?.customerProfileID = naviController?.reservationDetails?.customerProfileID
        }
        
        //Credit Card Data
        self.ticketBO?.creditCardInfo = naviController?.creditCardInfo
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let updateValetInfoService = UpdateValetInfoForTabletService()
        updateValetInfoService.delegate = self
        updateValetInfoService.updateValetInfoForTabletWebService(kUpdateValetInfoForTablet, parameters: ["Ticket":(self.ticketBO)!])
    }
    
    // MARK: - Keyboard notifications
    /**
     This method will scroll view to display text field based on keybaord height
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillShow(_ notification: Notification) {
        
        if self.currentEditedTextField == self.phoneNumberTextField {
            
            unowned let weakself = self
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                weakself.view.frame = CGRect(x: 0, y: -100, width: weakself.view.frame.size.width, height: weakself.view.frame.size.height)
            });
        }
    }
    
    /**
     This method will scroll view to previous position when keybaord dismiss
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillHide(_ notification: Notification) {
        
        if self.currentEditedTextField == self.phoneNumberTextField {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentEditedTextField = textField as? TextField
        return true
    }
    
    //MARK: Storyboard segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: ActionsheetManagerDelegate methods
    func getActionsheet(_ optionMenu:UIAlertController) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func getSelectedOptionFromActionsheet(_ selectedOption:String, parkingTypeID:String) {
        
        if naviController?.getParkingTypeIDFromParkingTypeName(selectedOption) > 0 {
            naviController?.updatedParkingTypeName = selectedOption
            naviController?.updatedParkingTypeID = naviController?.getParkingTypeIDFromParkingTypeName(selectedOption)
        }
        
        self.updateTextFieldsWithRequiredData()
    }
    
    //MARK: DSLCalendar
    func createCalendar() {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        calendarViewController = mainStroyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
        calendarViewController?.delegate = self
        if naviController?.updatedDate != nil && naviController?.updatedDate?.characters.count > 0 {
            calendarViewController!.visibleDate = Utility.dateFromString((naviController?.updatedDate)!, dateFormat: "yyyy.MM.dd")!
        }
        naviController!.view.addSubview(calendarViewController!.view)
    }
    
    //MARK: CalendarDelegate method
    func getDateAndTime(_ date:String, time:String) {
        
        naviController?.updatedDate = date
        self.updateTextFieldsWithRequiredData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.calendarViewController?.view.removeFromSuperview()
            self.calendarViewController = nil
        }
    }
    
    func dismissCalendar() {
        naviController?.updatedDate = nil
        self.returnDateTextfield.text = ""
        self.calendarViewController?.view.removeFromSuperview()
        self.calendarViewController = nil
    }
    
    //MARK: Timepicker
    func createTimepicker() {
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        timepickerViewController = mainStroyboard.instantiateViewController(withIdentifier: "TimepickerViewController") as? TimepickerViewController
        timepickerViewController?.delegate = self
        timepickerViewController?.selectedTime = naviController?.updatedTime
        naviController?.view.addSubview(timepickerViewController!.view)
    }
    
    //MARK: TimepickerDelegate method
    func getSelectedTime(_ time:String) {
        naviController?.updatedTime = time
        self.updateTextFieldsWithRequiredData()
        //        timepickerViewController = nil
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.timepickerViewController?.view.removeFromSuperview()
            self.timepickerViewController = nil
        }
    }
    
    func dismissTimePicker() {
        naviController?.updatedTime = nil
        self.returnTimeTextfield.text = ""
        self.timepickerViewController?.view.removeFromSuperview()
        self.timepickerViewController = nil
    }
    
    //MARK: UITextField method
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextfield {
            let nameArray = textField.text?.components(separatedBy: " ")
            naviController?.updatedFirstName = nameArray![0]
            naviController?.updatedLastName = nameArray?.count > 1 ? (self.getCustomStringFromArray(nameArray! as NSArray) ) : ""
            self.updateTextFieldsWithRequiredData()
        } else if textField == phoneNumberTextField {
            naviController?.phoneNumber = textField.text
            self.updateTextFieldsWithRequiredData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: TimepickerDelegate method
    func getCustomStringFromArray(_ array:NSArray) -> String {
        var nameString = ""
        for (index, value) in array.enumerated() {
            if index == 0 {
                continue
            }
            else if nameString.characters.count == 0 {
                nameString = value as! String
            }
            else if (value as! String).characters.count > 0 {
                nameString = nameString + " " + (value as! String)
            }
        }
        return nameString
    }
    
    //changes for scan/swipe
    
    // MARK: - IPC Machine Methods
    override func scannedBarcodeData(_ barcode: String!) {
        
        if barcode.contains("=") {
            
            naviController?.creditCardInfo = CreditCardInfoBO()
            _ = naviController?.creditCardInfo?.getCreditCardInfoBOFromSwipedCard(barcode)
            self.updateTextFieldsWithRequiredData()
            
            ActivityLogsManager.sharedInstance.logUserActivity(("Swiped credit card number \((naviController?.creditCardInfo?.maskedCardNumber)!)."), logType: "Normal")
            
            let alert = UIAlertController(title: "Successful", message:"Credit card number \((naviController?.creditCardInfo?.maskedCardNumber)!) linked successfully.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if Utility.checkForFPCardNumberIsValid(barcode) {
                self.fpcardTextfield.text = barcode
                /** search by fp card number */
                self.searchOrScanByReservationNumberOrByFPCardNumber(kValidateCardTypeEncryptedNumber, scannedNumber: barcode)
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned loyalty number: " + barcode), logType: "Normal")
                
            } else if Utility.checkForPreprintedNumberIsValid(barcode) {
                /** search by pre-printed ticket number */
                self.preprintedTicketTextField.text = barcode
                self.searchOrScanByReservationNumberOrByFPCardNumber(kValidateNumberService, scannedNumber: barcode)
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Pre-printed number: " + barcode), logType: "Normal")
                
            } else if Utility.isLax() && Utility.checkForBarcodeIsValid(barcode) {
                self.scannedBarcodeRes = barcode
                /** Check for barcode */
                Utility.sharedInstance.showHUDWithLabel("Loading...")
                let validateDiscountCardTypeManager:ValidateCardTypeEncryptedNumberService = ValidateCardTypeEncryptedNumberService()
                validateDiscountCardTypeManager.delegate = self
                let encryptedIdentifierKey: String = Encryptor.encrypt(barcode)
                validateDiscountCardTypeManager.validateCardTypeEncryptedNumberWebService(kValidateCardTypeEncryptedNumberForBarcode, parameters: ["IdentifierKey":encryptedIdentifierKey])
                
            } else if Utility.checkForReservationCodeIsValid(barcode) {
                /** search by reservation */
                self.reservationNumberTextField.text = barcode
                self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, scannedNumber: barcode)
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Reservation number: " + barcode), logType: "Normal")
            } else {
                let alert = UIAlertController(title: klError, message: "Invalid Input", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
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
    
    
    /**
     This method will call different API calls for fetching details.
     :param: reservationNumber string
     :param: FPcard number string
     :param: preprinted ticket number string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func searchOrScanByReservationNumberOrByFPCardNumber(_ identifier:String, scannedNumber:String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        
        switch (identifier) {
            
        case kValidateNumberService:
            
            let serviceManager: ValidateNumberService = ValidateNumberService()
            serviceManager.delegate = self
            serviceManager.validateNumberWebService(kValidateNumberService, parameters: ["PriprintedNumber": scannedNumber])
            
        case kLoadFrequentParkerByFPCardNoForReservation:
            
            let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
            loadFrequentParkerManager.delegate = self
            loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoForReservation, parameters: ["ReservationNumber":scannedNumber, "FPCardNumber":""])
            
            break
            
        case kValidateCardTypeEncryptedNumber:
            
            let validateDiscountCardTypeManager:ValidateCardTypeEncryptedNumberService = ValidateCardTypeEncryptedNumberService()
            validateDiscountCardTypeManager.delegate = self
            let encryptedIdentifierKey: String = Encryptor.encrypt(scannedNumber)
            validateDiscountCardTypeManager.validateCardTypeEncryptedNumberWebService(kValidateCardTypeEncryptedNumberForIdentifier, parameters: ["IdentifierKey":encryptedIdentifierKey])
            
            break
            
            //        case kLoadFrequentParkerByFPCardNo:
            //            let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
            //            loadFrequentParkerManager.delegate = self
            //            loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNo, parameters: ["ReservationNumber":"", "FPCardNumber":scannedNumber])
            //
        //            break
        default:
            break
        }
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
        if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
            self.loadCreditCardForFP(fpCardNo)
        }
    }
    
    func getFpCardFromMultipleCards(_ object: AnyObject, identifier: String) {
        
        if identifier == "FPCardWithReservation" {
            
            naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
            naviController?.contractCardDetails = nil
            self.updateTextFieldsWithRequiredData()
            //            ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (naviController?.reservationDetails?.fpCode)!), logType: "Normal")
            
            if naviController?.reservationDetails?.reservationCode?.characters.count > 0 {
                self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: (naviController?.reservationDetails?.reservationCode)!)
            }
        } else if identifier == "FPCard" {
            if let fpCardDetails = object as? ReservationAndFPCardDetailsBO {
                //                ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                if fpCardDetails.reservationID?.characters.count > 0 {
                    
                    self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                }else {
                    naviController?.reservationDetails = object as? ReservationAndFPCardDetailsBO
                    naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                    naviController?.contractCardDetails = nil
                    self.updateTextFieldsWithRequiredData()
                    //                        naviController?.popViewControllerAnimated(true)
                    if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                        Utility.sharedInstance.showHUDWithLabel("Loading...")
                        let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                        vehicleInformationManager.delegate = self
                        vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                    }else {
                        //                        _ = naviController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func loadCreditCardForFP(_ fpCardNumber: String) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let creditCardInfoManager:GetCreditCardAssociatedWithFPService = GetCreditCardAssociatedWithFPService()
        creditCardInfoManager.delegate = self
        creditCardInfoManager.getCreditCardAssociatedWithFPNoWebService(kGetCreditCardAssociatedWithFP, parameters:["FPCardNumber": fpCardNumber])
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let multipleTicketViewController = mainStroyboard.instantiateViewController(withIdentifier: "MultipleTicketsViewController") as? MultipleTicketsViewController
        multipleTicketViewController?.delegate = self
        
        switch (identifier) {
            
        case kGenerateTicketForTablet as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            if (responseDict.getStringFromDictionary(withKeys: ["GenerateTicketForTabletResponse","GenerateTicketForTabletResult","a:Status","a:ErrCode"]) as NSString) == "0" {
                naviController?.ticketNumber = responseDict.getStringFromDictionary(withKeys: ["GenerateTicketForTabletResponse","GenerateTicketForTabletResult","a:Result"]) as String
                
                let alert = UIAlertController(title: klSuccess, message: (kTicketCreated as String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let messageString = responseDict.getStringFromDictionary(withKeys: ["GenerateTicketForTabletResponse","GenerateTicketForTabletResult","a:Status","a:Message"]) as String
                
                let alert = UIAlertController(title: klError, message: (messageString as String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kCheckIsTicketAlreadyExistService as String:
            let responseDict: NSDictionary = response as! NSDictionary
            if (responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:ErrCode"]) as NSString) == "0" {
                
                self.callAddUpdateTicketForTablet()
                
            }else {
                let messageString = responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:Message"]) as String
                
                let alert = UIAlertController(title: klError, message: (messageString as String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            break
            
        case kAddUpdateVehicle as String:
            let responseDict: NSDictionary = response as! NSDictionary
            self.vehicleID = responseDict.getStringFromDictionary(withKeys: ["AddUpdateVehicleResponse","AddUpdateVehicleResult"]) as String
            self.callGenerateTicketForTablet()
            
            break
            
        case kVehicleInfoByVIN as String:
            
            naviController?.vehicleDetails = response as? VehicleDetailsBO
            
            break
            
        case kAddTicketUpdateValetInfoForTabletService as String:
            
            if naviController?.vehicleDetails?.vehicleVIN?.characters.count > 0 {
                
                self.callUpdateVehicleInfoAPI()
                
            } else {
                
                let alert = UIAlertController(title: klSuccess, message: (kTicketCreated as String), preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kUpdateValetInfoForTablet as String:
            
            if let _ = self.ticketBO?.vehicleDetails {
                
                Utility.sharedInstance.showHUDWithLabel("Loading...")
                let updateVehicleInfoService: UpdateVehicleInfoService = UpdateVehicleInfoService()
                updateVehicleInfoService.delegate = self
                updateVehicleInfoService.updateVehicleInfoService(kUpdateVehicleInfoService, parameters: ["VehicleDetailsBO":(self.ticketBO?.vehicleDetails)!, "TicketID":(self.ticketBO?.ticketID)!])
                
            } else {
                let alert = UIAlertController(title: klSuccess, message: "Ticket updated successfully", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kUpdateVehicleInfoService as String:
            
            let alert = UIAlertController(title: klSuccess, message: "Ticket updated successfully", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kValidateNumberService as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            if responseDict.getStringFromDictionary(withKeys: ["ValidateNumberResponse","ValidateNumberResult","a:Result"]) as NSString == "true" {
                if responseDict.getStringFromDictionary(withKeys: ["ValidateNumberResponse","ValidateNumberResult","a:Status","a:ErrCode"]) as NSString == "0" {
                    
                    naviController?.priprintedNumber = self.preprintedTicketTextField.text
                    naviController?.isTicketFromServer = false
                    self.updateTextFieldsWithRequiredData()
                    //                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid pre-printed number : " + (naviController?.priprintedNumber!)!), logType: "Normal")
                } else {
                    
                    let alert = UIAlertController(title: klError, message:"Preprinted number is not usable", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                        self.preprintedTicketTextField.text = ""
                    }))
                    self.present(alert, animated: true, completion: nil)
                    //                    ActivityLogsManager.sharedInstance.logUserActivity(("Invalid pre-printed number : " + self.preprintedTicketTextField.text!), logType: "Normal")
                }
            } else {
                let alert = UIAlertController(title: klError, message:"Preprinted number is not usable", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                    self.preprintedTicketTextField.text = ""
                }))
                self.present(alert, animated: true, completion: nil)
                //                ActivityLogsManager.sharedInstance.logUserActivity(("Invalid pre-printed number : " + self.preprintedTicketTextField.text!), logType: "Normal")
            }
            
            break
            
        case kValidateCardTypeEncryptedNumberForIdentifier as String:
            
            var cardTypeString = ""
            
            let cardTypeResponseDict: NSDictionary = response as! NSDictionary
            
            if let cardTypeDict: NSDictionary = cardTypeResponseDict.getObjectFromDictionary(withKeys: ["ValidateCardTypeEncryptedNumberResponse"]) as? NSDictionary {
                if let cardType = cardTypeDict.getInnerText(forKey: "ValidateCardTypeEncryptedNumberResult") {
                    cardTypeString = cardType
                }
            }
            
            //            ActivityLogsManager.sharedInstance.logUserActivity(("CardType of searched card is : " + cardTypeString), logType: "Normal")
            
            if cardTypeString == "VIP" || cardTypeString == "Employee" || cardTypeString == "ContractCard" {
                
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
            
        case kValidateCardTypeEncryptedNumberForBarcode as String:
            
            var cardTypeString = ""
            
            let cardTypeResponseDict: NSDictionary = response as! NSDictionary
            
            if let cardTypeDict: NSDictionary = cardTypeResponseDict.getObjectFromDictionary(withKeys: ["ValidateCardTypeEncryptedNumberResponse"]) as? NSDictionary {
                if let cardType = cardTypeDict.getInnerText(forKey: "ValidateCardTypeEncryptedNumberResult") {
                    cardTypeString = cardType
                }
            }
            
            if cardTypeString == "TicketNumber" {
                self.laxBarcodeTextField.text = self.scannedBarcodeRes
//                ActivityLogsManager.sharedInstance.logUserActivity(("Ticket number scanned : " + self.laxBarcodeTextField.text!), logType: "Normal")
                self.callTicketDetailsByBarcodeService(self.laxBarcodeTextField.text!)
                
            } else if cardTypeString == "ReservationNumber" {
                /** search by reservation */
                self.reservationNumberTextField.text = self.scannedBarcodeRes
                self.searchOrScanByReservationNumberOrByFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, scannedNumber: self.reservationNumberTextField.text!)
//                ActivityLogsManager.sharedInstance.logUserActivity(("Reservation number scanned : " + self.reservationNumberTextField.text!), logType: "Normal")
                
            } else {
                self.scannedBarcodeRes = ""
            }
            
            break
            
        case kGetContractCard as String:
            
            naviController?.contractCardDetails = response as? ContractCardInfoBO
            if naviController?.contractCardDetails?.cardNumber?.characters.count > 0 && naviController?.contractCardDetails?.cardNumber != nil {
                naviController?.reservationDetails?.fpCardNo = nil
                self.updateTextFieldsWithRequiredData()
                
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
            self.updateTextFieldsWithRequiredData()
            
            if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                naviController?.contractCardDetails = nil
                Utility.sharedInstance.showHUDWithLabel("Loading...")
                let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                vehicleInformationManager.delegate = self
                vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNo as String:
            
            if response.count > 1 {
                multipleTicketViewController!.fpCardWithReservationArray = response as? [ReservationAndFPCardDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                
            } else if response.count == 1 {
                if let fpCardDetails:ReservationAndFPCardDetailsBO = response.lastObject as? ReservationAndFPCardDetailsBO {
                    if fpCardDetails.reservationCode?.characters.count > 0 {
                        self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationCode!)
                    }else {
                        naviController?.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                        naviController?.updateDetailsFromReservationAndFPCardDetailsBO(naviController?.reservationDetails)
                        naviController?.contractCardDetails = nil
                        self.updateTextFieldsWithRequiredData()
                        
                        //                        ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (naviController?.reservationDetails?.fpCardNo)!), logType: "Normal")
                        if naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                            Utility.sharedInstance.showHUDWithLabel("Loading...")
                            let vehicleInformationManager:GetVehicleInfomationService = GetVehicleInfomationService()
                            vehicleInformationManager.delegate = self
                            vehicleInformationManager.getVehicleInfomationWebservice(kGetVehicleInfomation, parameters: NSDictionary())
                        }
                    }
                }
                
            } else {
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                    self.fpcardTextfield.text = ""
                }))
                self.present(alert, animated: true, completion: nil)
                //                ActivityLogsManager.sharedInstance.logUserActivity(("Invalid FP card number : " + (self.fpcardTextfield.text)!), logType: "Normal")
            }
            
            break
            
        case kGetVehicleInfomation as String:
            
            if response.count > 1 {
                
                multipleTicketViewController!.vehicleDetailsArray = response as? [VehicleDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                
            } else if response.count == 1 {
                naviController?.vehicleDetails = response.lastObject as? VehicleDetailsBO
                if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                    self.loadCreditCardForFP(fpCardNo)
                }
            } else {
                naviController?.vehicleDetails = nil
                if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                    self.loadCreditCardForFP(fpCardNo)
                }
            }
            
            break
            
        case kGetCreditCardAssociatedWithFP as String:
            
            let creditCardInfo = response as? CreditCardInfoBO
            
            if let _ = creditCardInfo, let _ = creditCardInfo?.cardNumber, creditCardInfo?.cardNumber?.characters.count > 0 {
                
                let alert = UIAlertController(title: klMessage, message:"Do you want to link credit card number '\((creditCardInfo?.maskedCardNumber)!)'?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                }))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    naviController?.creditCardInfo = creditCardInfo
                    self.updateTextFieldsWithRequiredData()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kGetTicketByBarcode as String:
            
            let ticket = response as! TicketBO
            
            //Vehicle and its Damages
            naviController?.vehicleDetails = ticket.vehicleDetails
            naviController?.isOversizeVehicle = (ticket.vehicleDetails?.isOversized)!
            naviController?.updateDetailsFromTicketBO(ticket)
            
            //Services
            if let _ = ticket.services {
                naviController?.servicesArray = ticket.services! as NSArray as? [ServiceBO]
                
                for selectedService in (naviController?.servicesArray)! {
                    
                    for key in (naviController?.serviceDictionary?.keys)! {
                        let servicesArray = naviController?.serviceDictionary?[key]
                        for service in servicesArray! {
                            if service.serviceTypeID == selectedService.serviceTypeID && service.serviceID == selectedService.serviceID {
                                service.isServiceSelected = true
                            }
                        }
                        naviController?.serviceDictionary?[key] = servicesArray
                    }
                }
            }
            
            //Reservation and FP
            naviController?.reservationDetails = ticket.reservationsArray?.last
            naviController?.reservationDetails?.customerProfileID = ticket.customerProfileID
            
            if let _ = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                naviController?.reservationDetails?.fpCode = naviController?.reservationDetails?.fpCardNo
            } else if let _ = naviController?.reservationDetails?.fpCode, naviController?.reservationDetails?.fpCode?.characters.count > 0 {
                naviController?.reservationDetails?.fpCardNo = naviController?.reservationDetails?.fpCode
            }
            
            if (naviController?.reservationDetails?.fpCardNo == nil || naviController?.reservationDetails?.fpCardNo?.characters.count == 0) && (ticket.fpCardNumber != nil && ticket.fpCardNumber?.characters.count > 0) {
                naviController?.reservationDetails?.fpCardNo = ticket.fpCardNumber
                naviController?.reservationDetails?.fpCode = ticket.fpCardNumber
            } else if (naviController?.reservationDetails?.fpCardNo == nil || naviController?.reservationDetails?.fpCardNo?.characters.count == 0) && (ticket.identifierKey != nil && ticket.identifierKey?.characters.count > 0) {
                naviController?.reservationDetails?.fpCardNo = ticket.identifierKey
                naviController?.reservationDetails?.fpCode = ticket.identifierKey
            }
            
            //Credit Card Data
            naviController?.creditCardInfo = ticket.creditCardInfo
            
            //For Update Ticket
            self.ticketBO = ticket
            
            self.updateTextFieldsWithRequiredData()
            
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
            //            _ = naviController?.popViewController(animated: true)
            if let fpCardNo = naviController?.reservationDetails?.fpCardNo, naviController?.reservationDetails?.fpCardNo?.characters.count > 0 {
                self.loadCreditCardForFP(fpCardNo)
            }
            
            break
            
        case kGetCreditCardAssociatedWithFP as String:
            break
            
        case kValidateNumberService as String:
            let alert = UIAlertController(title: klError, message:"Preprinted number is not usable", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                self.preprintedTicketTextField.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kLoadFrequentParkerByFPCardNo as String:
            let alert = UIAlertController(title: klError, message:"Invalid FP card", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                self.fpcardTextfield.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kLoadFrequentParkerByFPCardNoForReservation as String:
            let alert = UIAlertController(title: klError, message:"Invalid reservation", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                self.reservationNumberTextField.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kGetContractCard as String:
            
            let alert = UIAlertController(title: klError, message:"Invalid VIP number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                self.fpcardTextfield.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kUpdateVehicleInfoService as String:
            
            let alert = UIAlertController(title: klSuccess, message: "Ticket updated successfully", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            break
            
        default:
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
        }
    }
}
