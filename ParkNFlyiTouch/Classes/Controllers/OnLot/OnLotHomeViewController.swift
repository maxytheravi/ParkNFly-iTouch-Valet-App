//
//  OnLotHomeViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/23/15.
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


class OnLotHomeViewController: BaseViewController, ActionsheetManagerDelegate, DamagePictureTicketUpdateDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var ticketNumberTextfield: TextField!
    @IBOutlet weak var currentLocationTextfield: TextField!
    @IBOutlet weak var newLocationTextField: TextField!
    @IBOutlet weak var returnTimeTextfield: TextField!
    @IBOutlet weak var colorTextField: TextField!
    @IBOutlet weak var licenceTagTextfield: TextField!
    @IBOutlet weak var makeAndModelTextField: TextField!
    @IBOutlet weak var returnDateTextfield: TextField!
    @IBOutlet weak var parkingTypeTextfield: TextField!
    
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var serviceIconImageView: UIImageView!
    @IBOutlet weak var reservationIconImageView: UIImageView!
    @IBOutlet weak var fpCardIconImageView: UIImageView!
    @IBOutlet weak var creditCardIconImageView: UIImageView!
    @IBOutlet weak var locationHistoryTableView: UITableView!
    @IBOutlet weak var locationHistoryView: UIView!
    @IBOutlet weak var locationHistoryContainerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var serviceStatusButton: UIButton!
    @IBOutlet weak var damageButton: UIButton!
    @IBOutlet weak var customerInfoButton: UIButton!
    var locationHistoryArray: [LocationHistoryBO]!
    var locationId: String? = nil
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "On Lot"
        self.connectionStatusUpdate((naviController?.dtdev?.connstate)!)
        
        self.locationHistoryContainerView.layer.cornerRadius = 10.0
        self.locationHistoryContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.locationHistoryContainerView.layer.borderWidth = 2.0
        self.colorButton.layer.cornerRadius = 0.5 * self.colorButton.bounds.size.width
        self.colorButton.layer.borderColor = UIColor.darkGray.cgColor
        self.colorButton.layer.borderWidth = 1.5
        
        self.closeButton.layer.cornerRadius = 15.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        naviController!.dtdev!.connect()
        self.updateTextFieldsWithRequiredData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        naviController!.dtdev!.disconnect()
    }
    
    func updateTextFieldsWithRequiredData() {
        if naviController?.ticketBO != nil {
            
            self.customerInfoButton.isHidden = false
            
            if naviController?.ticketBO?.barcodeNumberString?.characters.count > 0 {
                self.ticketNumberTextfield.isUserInteractionEnabled = false
                self.ticketNumberTextfield.textColor = UIColor.ticketNumberTextColor(UIColor())()
                self.ticketNumberTextfield.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
                
                if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
                    self.ticketNumberTextfield.text = naviController?.ticketBO?.prePrintedTicketNumber
                }else {
                    self.ticketNumberTextfield.text = naviController?.ticketBO?.barcodeNumberString
                }
            }else {
                //                self.ticketNumberTextfield.userInteractionEnabled = true
                //                self.ticketNumberTextfield.text = ""
                //                self.ticketNumberTextfield.font = UIFont(name:"HelveticaNeue-Light", size: 14.0)
                //                self.ticketNumberTextfield.textColor = UIColor .blackColor()
            }
            self.parkingTypeTextfield.text = naviController?.ticketBO?.parkingTypeName
            
            if naviController?.ticketBO?.vehicleDetails?.licenseNumber != nil && naviController?.ticketBO?.vehicleDetails?.licenseNumber?.characters.count > 0 {
                self.licenceTagTextfield.text = naviController?.ticketBO?.vehicleDetails?.licenseNumber
                
            }/*else if naviController?.ticketBO?.licenseTag != nil && naviController?.ticketBO?.licenseTag?.characters.count > 0 {
                self.licenceTagTextfield.text = naviController?.ticketBO?.licenseTag
                
            }*/else {
                self.licenceTagTextfield.text = ""
            }
            
            if naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count > 0 && naviController?.ticketBO?.vehicleDetails?.vehicleModel?.characters.count > 0 {
                self.makeAndModelTextField.text = (naviController?.ticketBO?.vehicleDetails?.vehicleMake)! + " - " + (naviController?.ticketBO?.vehicleDetails?.vehicleModel)!
                
            }/*else if naviController?.ticketBO?.make?.characters.count > 0 && naviController?.ticketBO?.model?.characters.count > 0 {
                self.makeAndModelTextField.text = (naviController?.ticketBO?.make)! + " - " + (naviController?.ticketBO?.model)!
                
            }*/else if naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count > 0 && naviController?.ticketBO?.vehicleDetails?.vehicleModel?.characters.count == 0 {
                self.makeAndModelTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleMake
                
            } else if naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count == 0 && naviController?.ticketBO?.vehicleDetails?.vehicleModel?.characters.count > 0 {
                self.makeAndModelTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleModel
                
            }/*else if (naviController?.ticketBO?.make?.characters.count > 0 && naviController?.ticketBO?.model?.characters.count == 0){
                self.makeAndModelTextField.text = naviController?.ticketBO?.make
                
            } else if (naviController?.ticketBO?.make?.characters.count == 0 && naviController?.ticketBO?.model?.characters.count > 0){
                self.makeAndModelTextField.text = naviController?.ticketBO?.model
                
            }*/else {
                self.makeAndModelTextField.text = ""
            }
            
            if naviController?.ticketBO?.vehicleDetails?.vehicleColor?.characters.count > 0 {
                self.colorButton.isHidden = false
                self.colorTextField.placeholder = ""
                self.colorButton.backgroundColor = UIColor.getSelectedColor(UIColor())((naviController?.ticketBO?.vehicleDetails?.vehicleColor)!)
                
            }/*else if naviController?.ticketBO?.color?.characters.count > 0 {
                self.colorButton.hidden = false
                self.colorTextField.placeholder = ""
                self.colorButton.backgroundColor = UIColor.getSelectedColor(UIColor())((naviController?.ticketBO?.vehicleDetails?.vehicleColor)!)
                
            }*/else {
                self.colorButton.isHidden = true
            }
            
            let dateFormat = Utility.getFormatedDateBeforeT((naviController?.ticketBO?.toDateValetScan)!)
            let timeFromat = Utility.getFormatedTimeAfterT((naviController?.ticketBO?.toDateValetScan)!)
            
            if dateFormat.characters.count > 0 {
                self.returnDateTextfield.text = "RTN: " + Utility.dateStringFromString((dateFormat), dateFormat: "yyyy-MM-dd", conversionDateFormat: Utility.getDisplyDateFormat())!
            } else {
                self.returnDateTextfield.text = ""
            }
            
            if timeFromat.characters.count > 0 {
                self.returnTimeTextfield.text = Utility.dateStringFromString((timeFromat), dateFormat: "HH:mm:ss", conversionDateFormat: Utility.getDisplyTimeFormat())
            } else {
                self.returnTimeTextfield.text = ""
            }
            
            //            if naviController?.ticketBO?.locationID?.characters.count > 0 && naviController?.ticketBO?.locationID != nil {
            //
            //                for locationDetails:LocationBO in (naviController?.allLocationArray)! {
            //                    if locationDetails.locationID! == naviController?.ticketBO?.locationID {
            //                        self.currentLocationTextfield.text = locationDetails.locationName! as String
            //                    }
            //                }
            //            }
            
            self.currentLocationTextfield.text = naviController?.ticketBO?.spaceDescription
            
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
        
        self.setDamageButtonBackground()
        self.updateServiceStatusViewColor()
    }
    
    // MARK: - IPC Machine Methods
    override func scannedBarcodeData(_ barcode: String!) {
        
        self.nextTicketButtonAction(UIButton())
        self.ticketNumberTextfield.text = barcode
        self.loadTicketByTicketNumber(barcode)
        ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Barcode/Pri-printed number:" + barcode), logType: "Normal")
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
    }
    @IBAction func customerInfoButtonAction(_ sender: UIButton) {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let customPopOverViewController = mainStroyboard.instantiateViewController(withIdentifier: "CustomPopOverViewController") as? CustomPopOverViewController
        
        customPopOverViewController!.modalPresentationStyle = UIModalPresentationStyle.popover
        customPopOverViewController!.preferredContentSize = CGSize(width: 250.0, height: 80.0)
        customPopOverViewController!.popoverPresentationController!.delegate = self
        
        customPopOverViewController!.popoverPresentationController!.sourceView = sender
        customPopOverViewController!.popoverPresentationController!.sourceRect = CGRect(x: 0, y: sender.frame.size.height/2.0 - 5, width: 0, height: 0)
        customPopOverViewController!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.right
        customPopOverViewController!.popoverPresentationController?.backgroundColor = UIColor.white
        
        var customerDetailsString: String = ""
        customerDetailsString = "Name: " + (naviController?.ticketBO?.firstName == nil ? "" : (naviController?.ticketBO?.firstName)!) + " " + (naviController?.ticketBO?.lastName == nil ? "" : (naviController?.ticketBO?.lastName)!) + "\n" + "Phone No: " + (naviController?.ticketBO?.phoneNo == nil ? "" : (naviController?.ticketBO?.phoneNo)!) + "\n" + "Tier Status: " + (naviController?.ticketBO?.tier == nil ? "" : (naviController?.ticketBO?.tier)!) + "\n\n"
        
        customPopOverViewController!.descriptionText = customerDetailsString
        customPopOverViewController!.isCustomerInfo = true
        naviController!.present(customPopOverViewController!, animated: true, completion: { _ in })
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: - Clear data from screen
    func clearAllDataFromScreen(){
        
        self.ticketNumberTextfield.text = ""
        self.currentLocationTextfield.text = ""
        self.newLocationTextField.text = ""
        self.returnTimeTextfield.text = ""
        self.colorTextField.text = ""
        self.licenceTagTextfield.text = ""
        self.makeAndModelTextField.text = ""
        self.returnDateTextfield.text = ""
        self.parkingTypeTextfield.text = ""
        self.serviceIconImageView.isHidden = true
        self.reservationIconImageView.isHidden = true
        self.fpCardIconImageView.isHidden = true
        self.creditCardIconImageView.isHidden = true
        self.colorButton.isHidden = true
        self.customerInfoButton.isHidden = true
        
    }
    
    func setDamageButtonBackground() {
        
        if naviController?.ticketBO?.vehicleDetails?.damageMarksArray != nil && naviController?.ticketBO?.vehicleDetails?.damageMarksArray?.count > 0 && (naviController?.ticketBO?.vehicleDamages == nil || naviController?.ticketBO?.vehicleDamages?.count == 0) {
            self.damageButton.backgroundColor = UIColor.projectThemeRedColor(UIColor())()
        } else if naviController?.ticketBO?.vehicleDetails?.damageMarksArray != nil && naviController?.ticketBO?.vehicleDetails?.damageMarksArray?.count > 0 && (naviController?.ticketBO?.vehicleDamages != nil && naviController?.ticketBO?.vehicleDamages?.count > 0) {
            self.damageButton.backgroundColor = UIColor.projectThemeGreenColor(UIColor())()
        } else {
            self.damageButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
        }
    }
    
    func updateServiceStatusViewColor() {
        
        var redFound: Bool = false
        var yellowFound: Bool = false
        var greenFound: Bool = false
        
        if naviController?.ticketBO?.services?.count > 0 {
            
            for serviceBOObject in (naviController?.ticketBO?.services)! {
                
                let serviceBO: ServiceBO = serviceBOObject as! ServiceBO
                
                if let _ = serviceBO.serviceCompleted {
                    if serviceBO.serviceCompleted == "Completed" {
                        greenFound = true
                    } else if serviceBO.serviceCompleted == "InProgress" {
                        yellowFound = true
                    } else {
                        redFound = true
                        break
                    }
                } else {
                    redFound = true
                    break
                }
            }
            
            if redFound == true {
                self.serviceStatusButton.backgroundColor = UIColor.projectThemeRedColor(UIColor())()
            } else if yellowFound == true {
                self.serviceStatusButton.backgroundColor = UIColor.projectThemeYellowColor(UIColor())()
            } else if greenFound == true {
                self.serviceStatusButton.backgroundColor = UIColor.projectThemeGreenColor(UIColor())()
            } else {
                self.serviceStatusButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
            }
            
        } else {
            self.serviceStatusButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
        }
    }
    
    override func popingViewController() {
        naviController!.clearDataOnAppFlowChanged()
    }
    
    func loadTicketByTicketNumber(_ ticketNumber: String) {
        if ticketNumber.characters.count > 0 {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            naviController!.clearDataOnAppFlowChanged()
            self.clearAllDataFromScreen()
            let getTicketByBarcodeServiceManager: GetTicketByBarcodeService = GetTicketByBarcodeService()
            getTicketByBarcodeServiceManager.delegate  = self
            getTicketByBarcodeServiceManager.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["TicketNumber": ticketNumber])
        }else {
            let alert = UIAlertController(title: klError, message: klPleaseGiveValidInputs , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == self.ticketNumberTextfield {
            if self.ticketNumberTextfield.text?.characters.count > 0 {
                self.loadTicketByTicketNumber(self.ticketNumberTextfield.text!)
            }
            return true
        }
        return true
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.locationHistoryArray {
            return self.locationHistoryArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationHistoryCell") as! LocationHistoryCell
        
        let locationHistoryBO = self.locationHistoryArray[(indexPath as NSIndexPath).row]
        
        cell.userLabel.text = locationHistoryBO.cashierUserName
        cell.timeLabel.text = Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(locationHistoryBO.locationLogDate!), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyDateTimeFormat())
        cell.locationLabel.text = locationHistoryBO.locationName
        
        return cell
    }
    
    // MARK: - Button actions
    @IBAction func updateTicketContentButtonAction(_ sender: AnyObject) {
        //navigate to checkin homeviewcontroller
    }
    
    // MARK: Delegate Methods
    func ticketUpdateFromServer() {
        let barcode: String?
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            barcode = naviController?.ticketBO?.prePrintedTicketNumber
        } else {
            barcode = naviController?.ticketBO?.barcodeNumberString
        }
        self.nextTicketButtonAction(UIButton())
        self.ticketNumberTextfield.text = barcode!
        self.loadTicketByTicketNumber(barcode!)
    }
    
    // MARK: UIButton action
    /**
     This method will show UIAlertController for selected location names
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    @IBAction func locationButtonAction(_ sender: AnyObject) {
        
        //display credit card type options popover
        self.view.endEditing(true)
        if naviController?.ticketBO?.barcodeNumberString?.characters.count > 0 && naviController?.ticketBO?.barcodeNumberString != nil {
            
            let actionsheetView = ActionsheetObject()
            actionsheetView.delegate = self
            actionsheetView.createActionsheet((naviController?.allLocationArray)!, identifier: kLocationNamesActionSheet)
        }else {
            let alert = UIAlertController(title: klError, message: klTicketMissingMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editTicketButtonAction(_ sender: AnyObject) {
    }
    
    @IBAction func saveLocationButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if naviController?.ticketBO?.barcodeNumberString?.characters.count > 0 && naviController?.ticketBO?.barcodeNumberString != nil {
            if self.newLocationTextField.text?.characters.count > 0 && self.newLocationTextField.text != nil {
                
                naviController?.ticketBO?.spaceDescription = self.newLocationTextField.text
                Utility.sharedInstance.showHUDWithLabel("Loading...")
                
                let updateValetInfoService = UpdateValetInfoForTabletService()
                updateValetInfoService.delegate = self
                updateValetInfoService.updateValetInfoForTabletWebService(kUpdateValetInfoForTablet, parameters: ["Ticket":(naviController?.ticketBO)!])
               ActivityLogsManager.sharedInstance.logUserActivity(("Location of vehicle is updated by user: " + (naviController?.ticketBO?.spaceDescription)!), logType: "Normal")
                
            }else {
                let alert = UIAlertController(title: klError, message: klPleaseUpdateLocation, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }else {
            let alert = UIAlertController(title: klError, message: klTicketMissingMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextTicketButtonAction(_ sender: UIButton) {
        naviController!.clearDataOnAppFlowChanged()
        self.clearAllDataFromScreen()
        self.ticketNumberTextfield.isUserInteractionEnabled = true
        self.ticketNumberTextfield.font = UIFont(name:"HelveticaNeue-Regular", size: 14.0)
        self.ticketNumberTextfield.textColor = UIColor.black
        self.damageButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
        self.serviceStatusButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
        ActivityLogsManager.sharedInstance.logUserActivity(("Ticket is cleared from on-lot home screen"), logType: "Normal")
    }
    
    @IBAction func locationHistoryButtonAction(_ sender: AnyObject) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getLocationHistoryOfTicketService: GetLocationHistoryOfTicketService = GetLocationHistoryOfTicketService()
        getLocationHistoryOfTicketService.delegate  = self
        getLocationHistoryOfTicketService.getLocationHistoryOfTicketWebService(kGetLocationHistoryOfTicket, parameters: ["TicketNumber": (naviController?.ticketBO?.barcodeNumberString)!])
        ActivityLogsManager.sharedInstance.logUserActivity(("User loaded Location history"), logType: "Normal")
    }
    
    @IBAction func closeLocationHistoryButtonAction(_ sender: AnyObject) {
        self.locationHistoryView.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.locationHistoryView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.locationHistoryView.isHidden = true
        })
    }
    
    @IBAction func damagePictureButtonAction(_ sender: AnyObject) {
    }
    
    @IBAction func serviceStatusButtonAction(_ sender: AnyObject) {
        
        if naviController?.ticketBO?.services?.count > 0 {
            let mainStroyboard = Utility.createStoryBoardid(kOnlot)
            let serviceStatusViewController = mainStroyboard.instantiateViewController(withIdentifier: "ServiceStatusViewController") as? ServiceStatusViewController
            //        serviceStatusViewController?.services = naviController?.ticketBO?.services
            naviController?.pushViewController(serviceStatusViewController!, animated: true)
        } else {
            let alert = UIAlertController(title: klError, message: kServicesNotSelectec, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK : Custom Methods
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
                        }
                    }
                }
            }
        }
    }
    
    //    @IBAction func saveButtonAction(sender: AnyObject) {
    //
    //        Utility.sharedInstance.showHUDWithLabel("Loading...")
    //
    //        let updateValetInfoService = UpdateValetInfoForTabletService()
    //        updateValetInfoService.delegate = self
    //        updateValetInfoService.updateValetInfoForTabletWebService(kUpdateValetInfoForTablet, parameters: ["Ticket":(naviController?.ticketBO)!])
    //    }
    
    //MARK: ActionsheetManagerDelegate methods
    func getActionsheet(_ optionMenu:UIAlertController) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func getLoactionNameFromActionSheet(_ selectedOption: String) {
        //        self.newLocationTextField.text = selectedOption
        for locationDetails: LocationBO in (naviController?.allLocationArray)! {
            if locationDetails.locationName == selectedOption {
                self.locationId = locationDetails.locationID
            }
        }
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
    
    // MARK: Segue methods
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "UpdateTicketContentViewController" || identifier == "DamagePicture" {
            
            if naviController?.ticketBO == nil {
                
                let alert = UIAlertController(title: klError, message: klTicketMissingMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UpdateTicketContentViewController" {
            _ = segue.destination as! UpdateTicketContentViewController
        } else if segue.identifier == "DamagePicture" {
            let newDamagePictureViewController = segue.destination as! NewDamagePictureViewController
            newDamagePictureViewController.delegate = self
        }
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kUpdateValetInfoForTablet as String:
            self.newLocationTextField.text = ""
            let alert = UIAlertController(title: klSuccess, message: klSuccess, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.loadTicketToGetUpdatedTicketObject()
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
//            ActivityLogsManager.sharedInstance.logUserActivity(("Ticket information updated successfully : " + (naviController?.ticketBO?.barcodeNumberString)!), logType: "Normal")
//            ActivityLogsManager.sharedInstance.logUserActivity(("Location of vehicle is updated successfully : " + (naviController?.ticketBO?.spaceDescription)!), logType: "Normal")
            break
            
        case kGetTicketByBarcode as String:
            
            naviController?.ticketBO = response as? TicketBO
            naviController?.updateDetailsFromTicketBO(naviController?.ticketBO)
            self.updateTextFieldsWithRequiredData()
//            ActivityLogsManager.sharedInstance.logUserActivity(("Ticket fetched successfully :" + (naviController?.ticketBO?.barcodeNumberString)!), logType: "Normal")
            
            break
            
        case kGetLocationHistoryOfTicket as String:
            
            self.locationHistoryArray = response as? [LocationHistoryBO]
            
            if self.locationHistoryArray.count > 0 {
                
                self.locationHistoryTableView.reloadData()
                
                self.locationHistoryView.alpha = 0.0
                self.locationHistoryView.isHidden = false
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.locationHistoryView.alpha = 1.0
                })
                
//                ActivityLogsManager.sharedInstance.logUserActivity(("Location history is seen by user"), logType: "Normal")
                
            } else {
                let alert = UIAlertController(title: klError, message: "No history found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
