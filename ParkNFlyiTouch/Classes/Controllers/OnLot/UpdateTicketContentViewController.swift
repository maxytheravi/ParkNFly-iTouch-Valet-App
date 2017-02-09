//
//  UpdateTicketContentViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/24/15.
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


class UpdateTicketContentViewController: BaseViewController, ActionsheetManagerDelegate, CalendarDelegate, TimepickerDelegate, MultipleTicketsViewControllerDelegate {
    
    @IBOutlet weak var ticketNumberTextField: TextField!
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var reservationNumberTextField: TextField!
    @IBOutlet weak var fpcardTextfield: TextField!
    @IBOutlet weak var licenceNumberTextField: TextField!
    @IBOutlet weak var makeAndModelTextField: TextField!
    @IBOutlet weak var colorTextField: TextField!
    @IBOutlet weak var parkingTypeTextField: TextField!
    @IBOutlet weak var phoneNumberTextField: TextField!
    @IBOutlet weak var returnTimeTextField: TextField!
    @IBOutlet weak var returnDateTextField: TextField!
    weak var currentEditedTextField: TextField?
    
    @IBOutlet weak var colorButtonOutlet: UIButton!
    var selectedParkingTypeID: Int?
    var calendarViewController: CalendarViewController?
    var timepickerViewController: TimepickerViewController?
    var reservationDetails:ReservationAndFPCardDetailsBO?
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    @IBOutlet weak var serviceIconImageView: UIImageView!
    @IBOutlet weak var reservationIconImageView: UIImageView!
    @IBOutlet weak var fpCardIconImageView: UIImageView!
    @IBOutlet weak var creditCardIconImageView: UIImageView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Update Ticket"
        self.colorButtonOutlet.layer.cornerRadius = 0.5 * self.colorButtonOutlet.bounds.size.width
        self.colorButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        self.colorButtonOutlet.layer.borderWidth = 1.5
        
        naviController?.updatedFirstName = naviController?.ticketBO?.firstName
        naviController?.updatedLastName = naviController?.ticketBO?.lastName
        naviController?.phoneNumber = naviController?.ticketBO?.phoneNo
        naviController?.updatedParkingTypeName = naviController?.ticketBO?.parkingTypeName
        naviController?.updatedParkingTypeID = Int((naviController?.ticketBO?.parkingType)!)
        naviController?.updatedDate = Utility.getFormatedDateBeforeT((naviController?.ticketBO?.toDateValetScan)!)
        naviController?.updatedTime = Utility.getFormatedTimeAfterT((naviController?.ticketBO?.toDateValetScan)!)
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberTextField.text = naviController?.ticketBO?.prePrintedTicketNumber
        } else {
            self.ticketNumberTextField.text = naviController?.ticketBO?.barcodeNumberString
        }
        
        //Keyboard Done Button
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UpdateTicketContentViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.phoneNumberTextField.inputAccessoryView = numberToolbar
        
        self.connectionStatusUpdate((naviController?.dtdev?.connstate)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateTextFieldsWithRequiredData()
        
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
    
    func updateTextFieldsWithRequiredData() {
        
        if naviController?.ticketBO?.identifierKey?.characters.count > 0 || naviController?.ticketBO?.fpCardNumber?.characters.count > 0 {
            self.nameTextField.isUserInteractionEnabled = false
            self.phoneNumberTextField.isUserInteractionEnabled = false
        }
        
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberTextField.text = naviController?.ticketBO?.prePrintedTicketNumber
        }else {
            self.ticketNumberTextField.text = naviController?.ticketBO?.barcodeNumberString
        }
        
        if (naviController?.updatedFirstName?.characters.count > 0 && naviController?.updatedLastName?.characters.count > 0) {
            self.nameTextField.text = (naviController?.updatedFirstName)! + " " + (naviController?.updatedLastName)!
        }else if (naviController?.updatedFirstName?.characters.count > 0 && naviController?.updatedLastName?.characters.count == 0){
            self.nameTextField.text = (naviController?.updatedFirstName)!
        }else if (naviController?.updatedFirstName?.characters.count == 0 && naviController?.updatedLastName?.characters.count > 0){
            self.nameTextField.text = (naviController?.updatedLastName)!
        }else {
            self.nameTextField.text = ""
        }
        
        self.parkingTypeTextField.text = naviController?.updatedParkingTypeName
        self.selectedParkingTypeID = naviController?.updatedParkingTypeID
        //        self.returnDateTextField.text = naviController?.updatedDate
        //        self.returnTimeTextField.text = naviController?.updatedTime
        
        let dateFormat = Utility.getFormatedDateBeforeT((naviController?.updatedDate)!)
        let timeFromat = Utility.getFormatedTimeAfterT((naviController?.updatedTime)!)
        
        if dateFormat.characters.count > 0 {
            self.returnDateTextField.text = "RTN: " + Utility.dateStringFromString((dateFormat), dateFormat: "yyyy-MM-dd", conversionDateFormat: Utility.getDisplyDateFormat())!
        } else {
            self.returnDateTextField.text = ""
        }
        
        if timeFromat.characters.count > 0 {
            self.returnTimeTextField.text = Utility.dateStringFromString((timeFromat), dateFormat: "HH:mm:ss", conversionDateFormat: Utility.getDisplyTimeFormat())
        } else {
            self.returnTimeTextField.text = ""
        }
        
        if naviController?.ticketBO?.reservationsArray?.count > 0 {
            var reservationString: String = ""
            for reservation in (naviController?.ticketBO?.reservationsArray)! {
                
                if reservationString != "" {
                    reservationString += reservation.reservationCode! + ","
                }else {
                    reservationString = reservation.reservationCode! + ","
                }
            }
            reservationString.remove(at: reservationString.characters.index(before: reservationString.endIndex))
            self.reservationNumberTextField.text = "Res#: " + reservationString

//            for reservation:ReservationAndFPCardDetailsBO in (naviController?.ticketBO?.reservationsArray)! {
//                self.reservationNumberTextField.text = "Res#: " + reservation.reservationCode!
//                break
//            }
        } else {
            self.reservationNumberTextField.text = ""
        }
        
        if (naviController?.ticketBO?.fpCardNumber != nil && naviController?.ticketBO?.fpCardNumber?.characters.count > 0 ) {
            self.fpcardTextfield.text = "FP#: " + (naviController?.ticketBO?.fpCardNumber)!
        } else if (naviController?.ticketBO?.identifierKey != nil && naviController?.ticketBO?.identifierKey?.characters.count > 0) {
            self.fpcardTextfield.text = "FP#: " + (naviController?.ticketBO?.identifierKey)!
        } else if (naviController?.ticketBO?.contractCardNumber != nil && naviController?.ticketBO?.contractCardNumber?.characters.count > 0) {
            self.fpcardTextfield.text = "VIP#: " + (naviController?.ticketBO?.contractCardNumber)!
        }else {
            self.fpcardTextfield.text = ""
        }
        
        if naviController?.ticketBO?.vehicleDetails?.licenseNumber != nil && naviController?.ticketBO?.vehicleDetails?.licenseNumber?.characters.count > 0 {
            self.licenceNumberTextField.text = naviController?.ticketBO?.vehicleDetails?.licenseNumber
            
        }/*else if naviController?.ticketBO?.licenseTag != nil && naviController?.ticketBO?.licenseTag?.characters.count > 0 {
            self.licenceNumberTextField.text = naviController?.ticketBO?.licenseTag
            
        }*/else {
            self.licenceNumberTextField.text = ""
        }
        
        
        if naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count > 0 && naviController?.ticketBO?.vehicleDetails?.vehicleModel?.characters.count > 0 {
            self.makeAndModelTextField.text = (naviController?.ticketBO?.vehicleDetails?.vehicleMake)! + " - " + (naviController?.ticketBO?.vehicleDetails?.vehicleModel)!
            
        }/*else if naviController?.ticketBO?.make?.characters.count > 0 && naviController?.ticketBO?.model?.characters.count > 0 {
            self.makeAndModelTextField.text = (naviController?.ticketBO?.make)! + " - " + (naviController?.ticketBO?.model)!
            
        }*/ else if naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count > 0 && naviController?.ticketBO?.vehicleDetails?.vehicleModel?.characters.count == 0 {
            self.makeAndModelTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleMake
            
        } else if naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count == 0 && naviController?.ticketBO?.vehicleDetails?.vehicleModel?.characters.count > 0 {
            self.makeAndModelTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleModel
            
        }/* else if (naviController?.ticketBO?.make?.characters.count > 0 && naviController?.ticketBO?.model?.characters.count == 0){
            self.makeAndModelTextField.text = naviController?.ticketBO?.make
            
        } else if (naviController?.ticketBO?.make?.characters.count == 0 && naviController?.ticketBO?.model?.characters.count > 0){
            self.makeAndModelTextField.text = naviController?.ticketBO?.model
            
        }*/ else {
            self.makeAndModelTextField.text = ""
        }
        
        if naviController?.ticketBO?.vehicleDetails?.vehicleColor?.characters.count > 0 {
            self.colorButtonOutlet.isHidden = false
            self.colorButtonOutlet.backgroundColor = UIColor.getSelectedColor(UIColor())((naviController?.ticketBO?.vehicleDetails?.vehicleColor)!)
            self.colorTextField.placeholder = ""
            
        }/* else if naviController?.ticketBO?.color?.characters.count > 0 {
            self.colorButtonOutlet.hidden = false
            self.colorButtonOutlet.backgroundColor = UIColor.getSelectedColor(UIColor())((naviController?.ticketBO?.vehicleDetails?.vehicleColor)!)
            
        }*/ else {
            self.colorButtonOutlet.isHidden = true
            self.colorTextField.placeholder = "Color #"
        }
        
        self.phoneNumberTextField.text = naviController?.phoneNumber
        
        //Update Image Icons at Top
        if naviController?.ticketBO?.services != nil && naviController?.ticketBO?.services?.count > 0 {
            self.serviceIconImageView.isHidden = false
        } else {
            self.serviceIconImageView.isHidden = true
        }
        
        if naviController?.ticketBO?.reservationsArray != nil && naviController?.ticketBO?.reservationsArray?.count > 0 {
            self.reservationIconImageView.isHidden = false
        } else {
            self.reservationIconImageView.isHidden = true
        }
        
        if (naviController?.ticketBO?.fpCardNumber != nil && naviController?.ticketBO?.fpCardNumber?.characters.count > 0 ) || (naviController?.ticketBO?.identifierKey != nil && naviController?.ticketBO?.identifierKey?.characters.count > 0) {
            self.fpCardIconImageView.isHidden = false
        } else {
            self.fpCardIconImageView.isHidden = true
        }
        
        if let _ = naviController?.ticketBO?.creditCardInfo, let _ = naviController?.ticketBO?.creditCardInfo?.cardNumber, naviController?.ticketBO?.creditCardInfo?.cardNumber?.characters.count > 0 {
            self.creditCardIconImageView.isHidden = false
        } else {
            self.creditCardIconImageView.isHidden = true
        }
    }
    
    // MARK: - Custom Methods
    func updateServiceDictionaryWithSelectedServices() {
        
        if let _ = naviController?.ticketBO?.services {
            
            for serviceObj in (naviController?.ticketBO?.services)! {
                let service: ServiceBO = serviceObj as! ServiceBO
                for key in (naviController?.serviceDictionary?.keys)! {
                    let services: [ServiceBO] = (naviController?.serviceDictionary![key])!
                    for serviceBO in services {
                        if service.serviceID == serviceBO.serviceID {
                            serviceBO.isServiceSelected = true
                            serviceBO.serviceCompleted = service.serviceCompleted
                            serviceBO.serviceNotes = service.serviceNotes
                            serviceBO.cashierUserName = service.cashierUserName
                            serviceBO.serviceCharge = service.serviceCharge
                            serviceBO.quantity = service.quantity
                            serviceBO.totalServiceCharge = service.totalServiceCharge
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - IPC Machine Methods
    override func scannedBarcodeData(_ barcode: String!) {
        
        if Utility.checkForFPCardNumberIsValid(barcode) {
            /** search by fp card number */
            self.callLoadFPServiceByFPCardNo(barcode)
            ActivityLogsManager.sharedInstance.logUserActivity(("Scanned loyalty number: " + barcode), logType: "Normal")
            
        } else if Utility.checkForReservationCodeIsValid(barcode) {
            /** search by reservation */
            self.callLoadFPServiceByReservationNumber(barcode)
            ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Reservation number: " + barcode), logType: "Normal")
        } else {
            let alert = UIAlertController(title: klError, message: "Invalid Input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
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
    
    // MARK: - Button Actions
    @IBAction func parkingTypeButtonAction(_ sender: AnyObject) {
        //display parking type options popover
        let actionsheetView = ActionsheetObject()
        actionsheetView.delegate = self
        actionsheetView.createActionsheet((naviController?.productArray)!, identifier: kParkingTypeActionSheet)
        ActivityLogsManager.sharedInstance.logUserActivity(("Parking type button is tapped"), logType: "Normal")
    }
    
    @IBAction func returnDateButtonAction(_ sender: AnyObject) {
        //display calender
        createCalendar()
    }
    
    @IBAction func returnTimeButtonAction(_ sender: AnyObject) {
        //display timepicker
        createTimepicker()
    }
    
    @IBAction func vehicleButtonAction(_ sender: AnyObject) {
        
        //display vehicle screen
        let checkinStroyboardId = Utility.createStoryBoardid(kMain)
        let vehicleViewController = checkinStroyboardId.instantiateViewController(withIdentifier: "VehicleViewController") as! VehicleViewController
        naviController?.pushViewController(vehicleViewController, animated: true)
        ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle button is tapped"), logType: "Normal")
    }
    
    @IBAction func fpOrReservationButtonAction(_ sender: AnyObject) {
        
        //display start screen
        let checkinStroyboardId = Utility.createStoryBoardid(kMain)
        let searchTicketViewController = checkinStroyboardId.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
        naviController?.pushViewController(searchTicketViewController, animated: true)
        ActivityLogsManager.sharedInstance.logUserActivity(("FP/Reservation button is tapped"), logType: "Normal")
        
//        self.scannedBarcodeData("MRS740")
    }
    
    @IBAction func servicesButtonAction(_ sender: AnyObject) {
        
        self.updateServiceDictionaryWithSelectedServices()
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let servicesViewController = mainStroyboard.instantiateViewController(withIdentifier: "ServicesViewController") as? ServicesViewController
        naviController?.pushViewController(servicesViewController!, animated: true)
        ActivityLogsManager.sharedInstance.logUserActivity(("Service button is tapped"), logType: "Normal")
    }
    @IBAction func noteButtonAction(_ sender: AnyObject) {
    }
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        
        if (naviController?.ticketBO?.fpCardNumber?.characters.count > 0 || naviController?.ticketBO?.identifierKey?.characters.count > 0) && naviController?.ticketBO?.vehicleDetails != nil {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let addUpdateVehicleManager:AddUpdateVehicleService = AddUpdateVehicleService()
            addUpdateVehicleManager.delegate = self
            addUpdateVehicleManager.addUpdateVehicleInOnLotWebService(kAddUpdateVehicle, parameters: NSDictionary())
        }else {
            self.callUpdateValetInfoForTabletForTablet()
        }
        ActivityLogsManager.sharedInstance.logUserActivity(("Save button is tapped for storing all the updated information of ticket to server"), logType: "Normal")
    }
    
    func callCheckIsTicketAlreadyExistServiceAPI() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let checkIsTicketAlreadyExistServiceManager:CheckIsTicketAlreadyExistService = CheckIsTicketAlreadyExistService()
        checkIsTicketAlreadyExistServiceManager.delegate = self
        checkIsTicketAlreadyExistServiceManager.checkIsTicketAlreadyExistWebServiceForOnLot(kCheckIsTicketAlreadyExistService, parameters:NSDictionary())
    }
    
    func callCheckIsTicketAlreadyExistServiceAPI(_ reservationCode: String) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let checkIsTicketAlreadyExistServiceManager:CheckIsTicketAlreadyExistService = CheckIsTicketAlreadyExistService()
        checkIsTicketAlreadyExistServiceManager.delegate = self
        checkIsTicketAlreadyExistServiceManager.checkIsTicketAlreadyExistWebServiceForOnLot(kCheckIsTicketAlreadyExistService, parameters:["ReservationNumber":reservationCode])
    }
    
    func callUpdateTicketForTablet() {
        
        naviController?.ticketBO?.firstName = naviController?.updatedFirstName
        naviController?.ticketBO?.lastName = naviController?.updatedLastName
        naviController?.ticketBO?.parkingTypeName = naviController?.updatedParkingTypeName
        naviController?.ticketBO?.parkingType = "\((naviController?.updatedParkingTypeID)!)"
        naviController?.ticketBO?.toDateValetScan = (naviController?.updatedDate)! + (naviController?.updatedTime)!
        
        naviController?.ticketBO?.phoneNo = naviController?.phoneNumber
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let updateValetInfoService = UpdateValetInfoForTabletService()
        updateValetInfoService.delegate = self
        updateValetInfoService.updateValetInfoForTabletWebService(kUpdateValetInfoForTablet, parameters: ["Ticket":(naviController?.ticketBO)!])
    }
    
    func callUpdateValetInfoForTabletForTablet() {
//        Utility.sharedInstance.showHUDWithLabel("Loading...")
        self.callUpdateTicketForTablet()
        
//        if naviController?.ticketBO?.reservationsArray?.count > 0 && naviController?.isReservationSearched == true {
//            
//            self.callCheckIsTicketAlreadyExistServiceAPI()
//            
//        }else {
//            self.callUpdateTicketForTablet()
//        }
    }
    
    func callLoadFPServiceByFPCardNo(_ fpCardNo:String) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
        loadFrequentParkerManager.delegate = self
        loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNo, parameters: ["ReservationNumber":"", "FPCardNumber":fpCardNo])
    }
    
    func callLoadFPServiceByReservationNumber(_ reservationNumber:String) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
        loadFrequentParkerManager.delegate = self
        loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoForReservation, parameters: ["ReservationNumber":reservationNumber, "FPCardNumber":""])
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentEditedTextField = textField as? TextField
        return true
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
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: UITextField method
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.nameTextField {
            let nameArray = textField.text?.components(separatedBy: " ")
            naviController?.updatedFirstName = nameArray![0] 
            naviController?.updatedLastName = nameArray?.count > 1 ? (self.getCustomStringFromArray(nameArray! as NSArray) ) : ""
            ActivityLogsManager.sharedInstance.logUserActivity(("Name of the user updated to " + (naviController?.updatedFirstName)! + "" + (naviController?.updatedLastName)! ), logType: "Normal")
            self.updateTextFieldsWithRequiredData()
        } else if textField == phoneNumberTextField {
            naviController?.phoneNumber = textField.text
            ActivityLogsManager.sharedInstance.logUserActivity(("Phone number of the user updated to " + (naviController?.phoneNumber)! ), logType: "Normal")
            self.updateTextFieldsWithRequiredData()
        }else if textField == parkingTypeTextField {
            ActivityLogsManager.sharedInstance.logUserActivity(("Parking type updated to " + (naviController?.updatedParkingTypeName)! ), logType: "Normal")
        }else if textField == returnDateTextField {
            ActivityLogsManager.sharedInstance.logUserActivity(("Return date updated to " + (naviController?.updatedDate)! ), logType: "Normal")
        }else if textField == returnTimeTextField {
            ActivityLogsManager.sharedInstance.logUserActivity(("Return time updated to " + (naviController?.updatedTime)! ), logType: "Normal")
        }
    }
    
    //MARK: Name seperation method
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
    
    //MARK: DSLCalendar
    func createCalendar() {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        calendarViewController = mainStroyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
        calendarViewController?.delegate = self
        if naviController?.updatedDate != nil && naviController?.updatedDate?.characters.count > 0 {
            calendarViewController!.visibleDate = Utility.dateFromString((naviController?.updatedDate)!, dateFormat: "yyyy-MM-dd")!
        }
        naviController!.view.addSubview(calendarViewController!.view)
    }
    
    //MARK: Timepicker
    func createTimepicker() {
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        timepickerViewController = mainStroyboard.instantiateViewController(withIdentifier: "TimepickerViewController") as? TimepickerViewController
        timepickerViewController?.delegate = self
        timepickerViewController?.selectedTime = naviController?.updatedTime
        naviController?.view.addSubview(timepickerViewController!.view)
    }
    
    //MARK: - MultipleTicketsViewController methods
    func getFpCardFromMultipleCards(_ object: AnyObject, identifier: String) {
        
        if identifier == "FPCardWithReservation" {
            self.reservationDetails = object as? ReservationAndFPCardDetailsBO
//            ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (self.reservationDetails?.reservationCode)!), logType: "Normal")
            self.saveValidReservationAndFPcard()
            
        } else if identifier == "FPCard" {
            if let fpCardDetails = object as? ReservationAndFPCardDetailsBO {
//                ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + (fpCardDetails.fpCardNo)!), logType: "Normal")
                if fpCardDetails.reservationID?.characters.count > 0 {
                    self.getReservationDetailsFromFPCardNumber(kLoadFrequentParkerByFPCardNoForReservation, reservationNumber: fpCardDetails.reservationID!)
                }else {
                    self.reservationDetails = object as? ReservationAndFPCardDetailsBO
                    self.saveValidReservationAndFPcard()
                }
            }
        }
    }
    
    //MARK: ActionsheetManagerDelegate methods
    func getActionsheet(_ optionMenu:UIAlertController) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func getSelectedOptionFromActionsheet(_ selectedOption:String, parkingTypeID:String) {
        
        if Int(parkingTypeID) > 0 {
            naviController?.updatedParkingTypeID = Int(parkingTypeID)
            naviController?.updatedParkingTypeName = selectedOption
        }
        
        self.updateTextFieldsWithRequiredData()
        
        //        self.parkingTypeTextField.text = selectedOption
        //        self.selectedParkingTypeID = Int(parkingTypeID)
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
        self.calendarViewController?.view.removeFromSuperview()
        self.calendarViewController = nil

    }
    
    //MARK: TimepickerDelegate method
    func getSelectedTime(_ time:String) {
        //Viewcontroller comes for update data save time
        //Update ticketBO
        
        naviController?.updatedTime = time
        
        self.updateTextFieldsWithRequiredData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.timepickerViewController?.view.removeFromSuperview()
            self.timepickerViewController = nil
        }
    }
    
    func dismissTimePicker() {
        self.timepickerViewController?.view.removeFromSuperview()
        self.timepickerViewController = nil
    }
    
    // MARK: - Connection Delegates
    func loadTicketToGetUpdatedTicketObject() {
        
        let barcodeNumberString = naviController?.ticketBO?.barcodeNumberString
        
        naviController!.clearDataOnAppFlowChanged()
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        
        let getTicketByBarcodeServiceManager: GetTicketByBarcodeService = GetTicketByBarcodeService()
        getTicketByBarcodeServiceManager.delegate  = self
        getTicketByBarcodeServiceManager.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["TicketNumber": barcodeNumberString!])
    }
    
    func saveValidReservationAndFPcard() {
        
        if self.reservationDetails?.fpCardNo?.characters.count > 0 && self.reservationDetails?.fpCardNo != ""/* && self.reservationDetails?.reservationCode?.characters.count == 0 && self.reservationDetails?.reservationCode == ""*/  {
            naviController?.updateDetailsFromReservationAndFPCardDetailsBO(self.reservationDetails)
            naviController?.ticketBO?.fpCardNumber = self.reservationDetails?.fpCardNo
            naviController?.ticketBO?.customerProfileID = self.reservationDetails?.customerProfileID
            naviController?.ticketBO?.identifierKey = self.reservationDetails?.fpCardNo
        }
        
        if self.reservationDetails?.reservationCode?.characters.count > 0 && self.reservationDetails?.reservationCode != "" {
            self.callCheckIsTicketAlreadyExistServiceAPI((self.reservationDetails?.reservationCode)!)
        } else {
            self.updateTextFieldsWithRequiredData()
        }
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
    }
    
    // MARK: update reservation details
    func getReservationDetailsFromFPCardNumber(_ identifier:String, reservationNumber: String) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let loadFrequentParkerManager:LoadFrequentParkerByFPCardNoService = LoadFrequentParkerByFPCardNoService()
        loadFrequentParkerManager.delegate = self
        loadFrequentParkerManager.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoForReservation, parameters: ["ReservationNumber":reservationNumber, "FPCardNumber":""])
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let multipleTicketViewController = mainStroyboard.instantiateViewController(withIdentifier: "MultipleTicketsViewController") as? MultipleTicketsViewController
        multipleTicketViewController?.delegate = self
        
        switch (identifier) {
            
        case kUpdateValetInfoForTablet as String:
            
            let alert = UIAlertController(title: klSuccess, message: klSuccess, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.loadTicketToGetUpdatedTicketObject()
            })
            alert.addAction(okAction)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Ticket information updated successfully: " + (naviController?.ticketBO?.barcodeNumberString)!), logType: "Normal")
            self.present(alert, animated: true, completion: nil)
            break
            
        case kGetTicketByBarcode as String:
            
            naviController?.ticketBO = response as? TicketBO
            naviController?.updateDetailsFromTicketBO(naviController?.ticketBO)
//            ActivityLogsManager.sharedInstance.logUserActivity(("The ticket information is fetched successfully : " + (naviController?.ticketBO?.barcodeNumberString)!), logType: "Normal")
            _ = naviController?.popViewController(animated: true)
            
            break
            
        case kAddUpdateVehicle as String:
            let responseDict: NSDictionary = response as! NSDictionary
            naviController?.ticketBO?.vehicleID = responseDict.getStringFromDictionary(withKeys: ["AddUpdateVehicleResponse","AddUpdateVehicleResult"]) as String
//            ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle updated successfully in the ticket information : " + (naviController?.ticketBO?.barcodeNumberString)!), logType: "Normal")
            self.callUpdateValetInfoForTabletForTablet()
            
            break
            
            /*case kCheckIsTicketAlreadyExistService as String:
             let responseDict: NSDictionary = response as! NSDictionary
             if (responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:ErrCode"]) as NSString) == "0" {
             
             self.callUpdateTicketForTablet()
             
             }else {
             if naviController?.isReservationSearched == true {
             naviController?.ticketBO?.reservationsArray?.removeLast()
             }
             
             let messageString = responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:Message"]) as String
             
             let alert = UIAlertController(title: klError, message: (messageString as String), preferredStyle: UIAlertControllerStyle.alert)
             alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             Utility.sharedInstance.hideHUD()
             }
             break*/
            
        case kLoadFrequentParkerByFPCardNo as String:
            
            if response.count > 1 {
                
                multipleTicketViewController!.fpCardWithReservationArray = response as? [ReservationAndFPCardDetailsBO]
                self.present(multipleTicketViewController!, animated: true, completion: nil)
                
            } else if response.count == 1 {
                
                self.reservationDetails = response.lastObject as? ReservationAndFPCardDetailsBO
                self.saveValidReservationAndFPcard()
                
//                if let _ = reservationDetails.fpCardNo {
//                    
//                    ActivityLogsManager.sharedInstance.logUserActivity(("Valid FP card number : " + reservationDetails.fpCardNo!), logType: "Normal")
//                    
//                    naviController?.ticketBO?.fpCardNumber = reservationDetails.fpCardNo
//                    naviController?.ticketBO?.customerProfileID = reservationDetails.customerProfileID
//                    naviController?.ticketBO?.identifierKey = reservationDetails.fpCardNo
//                    
//                    self.updateTextFieldsWithRequiredData()
//                    
//                    self.saveValidReservationAndFPcard()
//                }
                
            } else {
//                ActivityLogsManager.sharedInstance.logUserActivity(("Invalid FP card number : " + (self.fpcardTextfield.text)!), logType: "Normal")
                let alert = UIAlertController(title: klError, message:klNoRecordFound, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
                    //                    self.fpcardTextfield.text = ""
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNoForReservation as String:
            
            self.reservationDetails = response as? ReservationAndFPCardDetailsBO
//            ActivityLogsManager.sharedInstance.logUserActivity(("Valid reservation number : " + (self.reservationDetails?.reservationCode)!), logType: "Normal")
            
            if self.reservationDetails?.reservationCode?.characters.count > 0 && self.reservationDetails?.reservationCode != "" {
                self.callCheckIsTicketAlreadyExistServiceAPI((self.reservationDetails?.reservationCode)!)
            }
            
            break
            
        case kCheckIsTicketAlreadyExistService as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            if (responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:ErrCode"]) as NSString) == "0" {
                
                self.addReservationInTicket()
                self.updateTextFieldsWithRequiredData()
                
            } else {
                
                let messageString = responseDict.getStringFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult","a:Status","a:Message"]) as String
                
                let alert = UIAlertController(title: klError, message: (messageString as String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                Utility.sharedInstance.hideHUD()
            }
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
    
}
