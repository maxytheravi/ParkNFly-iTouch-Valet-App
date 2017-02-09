//
//  VehicleViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/24/15.
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


class VehicleViewController: BaseViewController, MultipleTicketsViewControllerDelegate, ScanViewControllerDelegate, ColorSelectionViewControllerDelegate, ColorSelectionViewDelegate, VehicleMakeViewControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var licenceTagTextField: TextField!
    @IBOutlet weak var ticketNumberTextField: TextField!
    @IBOutlet weak var vehicleMakeTextField: TextField!
    @IBOutlet weak var vehicleColorTextField: TextField!
    @IBOutlet weak var vehicleModelTextField: TextField!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    @IBOutlet weak var oversizeSwitch: UISwitch!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var vinScanButtonOutlet: UIButton!
    
    @IBOutlet weak var colorButtonOutlet: UIButton!
    var vehicleBO: VehicleDetailsBO?
    var VINNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vehicle"
        self.colorButtonOutlet.layer.cornerRadius = 0.5 * self.colorButtonOutlet.bounds.size.width
        self.colorButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        self.colorButtonOutlet.layer.borderWidth = 1.5
        
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
            if naviController?.vehicleDetails == nil {
                self.vehicleBO = VehicleDetailsBO()
            } else {
                self.vehicleBO = naviController?.vehicleDetails
            }
            self.updateDetailsFromResponses(self.vehicleBO!)
            self.oversizeSwitch.isOn = (naviController?.isOversizeVehicle)!
            
        } else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow)  {
            if naviController?.ticketBO?.vehicleDetails == nil/* && self.validateData() == false*/ {
                self.vehicleBO = VehicleDetailsBO()
            } else /*if naviController?.ticketBO?.vehicleDetails?.vehicleVIN?.characters.count > 0 || naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count > 0 */{
                self.vehicleBO = naviController?.ticketBO?.vehicleDetails
            }
            //             else {
            //                self.vehicleBO = VehicleDetailsBO()
            //                self.vehicleBO?.vehicleColor = naviController?.ticketBO?.color
            //                self.vehicleBO?.vehicleMake = naviController?.ticketBO?.make
            //                self.vehicleBO?.vehicleModel = naviController?.ticketBO?.model
            //                self.vehicleBO?.licenseNumber = naviController?.ticketBO?.licenseTag
            //            }
            self.updateDetailsFromResponses(self.vehicleBO!)
            self.oversizeSwitch.isOn = (naviController?.ticketBO?.vehicleDetails?.isOversized)!
            self.connectionStatusUpdate((naviController?.dtdev?.connstate)!)
        }
        
//        self.scannedBarcodeData("1J4GW58S1XC675729")
    }
    
    func validateData() -> Bool {
        
        if naviController?.ticketBO?.vehicleDetails?.vehicleMake == nil || naviController?.ticketBO?.vehicleDetails?.vehicleModel == nil || naviController?.ticketBO?.vehicleDetails?.vehicleColor == nil || naviController?.ticketBO?.vehicleDetails?.licenseNumber == nil {
            return false
        }else {
            return true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
            self.ticketNumberTextField.isHidden = false
            self.ticketNumberTextField.textColor = UIColor.ticketNumberTextColor(UIColor())()
            self.ticketNumberTextField.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
            if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
                self.ticketNumberTextField.text = naviController?.ticketBO?.prePrintedTicketNumber
            }else {
                self.ticketNumberTextField.text = naviController?.ticketBO?.barcodeNumberString
            }
            
        }else if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
            self.ticketNumberTextField.isHidden = true
            //            self.nsLayoutConstraintForHeight.constant = 21.00
            //            self.licenceTagTextField.userInteractionEnabled = true
            //            _ = NSLayoutConstraint(item: self.textfieldView, attribute: .Height, relatedBy: .Equal, toItem: self.vinScanButtonOutlet, attribute:.Height, multiplier: 1.0, constant:65.0).active = true
        }
        naviController!.dtdev!.connect()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        naviController!.dtdev!.disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDetailsFromResponses(_ vehicleBO: VehicleDetailsBO) {
        //        if vehicleBO.licenseNumber != nil && vehicleBO.licenseNumber?.characters.count > 0 {
        //            self.licenceTagTextField.text = vehicleBO.licenseNumber
        //        }else {
        self.licenceTagTextField.text = vehicleBO.licenseNumber
        //        }
        self.vehicleMakeTextField.text = vehicleBO.vehicleMake
        self.vehicleModelTextField.text = vehicleBO.vehicleModel
        //        self.vehicleColorTextField.text = vehicleBO.vehicleColor
        if vehicleBO.vehicleColor?.characters.count > 0 {
            self.colorButtonOutlet.isHidden = false
            self.vehicleColorTextField.placeholder = ""
            self.colorButtonOutlet.backgroundColor = UIColor.getSelectedColor(UIColor())((vehicleBO.vehicleColor)!)
            
        }else {
            self.colorButtonOutlet.isHidden = true
            self.vehicleColorTextField.placeholder = "Vehicle Color"
        }
        
    }
    
    func updateSwitchStatusByModel() {
        if self.vehicleModelTextField.text == "SUV/CrossOver" || self.vehicleModelTextField.text == "Truck" || self.vehicleModelTextField.text == "Van/Minivan" || self.vehicleModelTextField.text == "AWD/4WD" {
            self.oversizeSwitch.setOn(true, animated: true)
        }else {
            self.oversizeSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func colorButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        let colorSelectionView = Bundle.main.loadNibNamed("ColorSelectionView", owner: nil, options: nil)![0] as! ColorSelectionView
        colorSelectionView.delegate = self
        colorSelectionView.frame = (naviController?.view.bounds)!
        naviController?.view.addSubview(colorSelectionView)
        ActivityLogsManager.sharedInstance.logUserActivity(("COlor button is tapped"), logType: "Normal")
    }
    
    @IBAction func scanVINButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        let mainStroyboardId = Utility.createStoryBoardid(kMain)
        let scanViewController = mainStroyboardId.instantiateViewController(withIdentifier: "ScanViewController") as! ScanViewController
        scanViewController.delegate = self
        scanViewController.scanType = ScanType.kVINNumber
        naviController?.pushViewController(scanViewController, animated: true)
    }
    @IBAction func switchButtonActionMethodd(_ sender: AnyObject) {
    }
    
    @IBAction func makeButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
    }
    
    //changes for new scan flow
    // MARK: - IPC Machine Methods
    override func scannedBarcodeData(_ barcode: String!) {
        
        self.VINNumber = self.validateVINNumber(barcode)
        self.callVINService()
        ActivityLogsManager.sharedInstance.logUserActivity(("Scanned VIN number: " + barcode), logType: "Normal")
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
    
    // MARK: - WebService calls
    func callVINService() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getVehicleInfoByVINService: GetVehicleInfoByVINService = GetVehicleInfoByVINService()
        getVehicleInfoByVINService.delegate = self
        getVehicleInfoByVINService.getVehicleInfoByVINService(kVehicleInfoByVIN, parameters:["VIN": self.VINNumber])
    }
    
    
    func getSelectedColor(_ selectedColor: Int) {
        
        var colorDetected = true
        
        switch(selectedColor) {
            
        case 1:
            self.vehicleBO?.vehicleColor = "Marron"
            break
            
        case 2:
            self.vehicleBO?.vehicleColor = "Red"
            break
            
        case 3:
            self.vehicleBO?.vehicleColor = "Blue"
            break
            
        case 4:
            self.vehicleBO?.vehicleColor = "Green"
            break
            
        case 5:
            self.vehicleBO?.vehicleColor = "Yellow"
            break
            
        case 6:
            self.vehicleBO?.vehicleColor = "Orange"
            break
            
        case 7:
            self.vehicleBO?.vehicleColor = "Purple"
            break
            
        case 8:
            self.vehicleBO?.vehicleColor = "Goldenrod"
            break
            
        case 9:
            self.vehicleBO?.vehicleColor = "DarkGray"
            break
            
        case 10:
            self.vehicleBO?.vehicleColor = "Gray"
            break
            
        case 11:
            self.vehicleBO?.vehicleColor = "White"
            break
            
        case 12:
            self.vehicleBO?.vehicleColor = "Black"
            break
            
        default:
            colorDetected = false
            break
        }
        
        //        vehicleColorTextField.text = self.vehicleBO?.vehicleColor
        if vehicleBO?.vehicleColor?.characters.count > 0 && colorDetected == true {
            self.colorButtonOutlet.isHidden = false
            self.vehicleColorTextField.placeholder = ""
            self.colorButtonOutlet.backgroundColor = UIColor.getSelectedColor(UIColor())((vehicleBO!.vehicleColor)!)
            
        }else {
            self.colorButtonOutlet.isHidden = true
            self.vehicleColorTextField.placeholder = "Vehicle Color"
        }
    }
    
    /*!
     @function      hexStringFromColor
     @abstract      This method converts color to hexstring value
     @param         UIColor
     @result        NSString
     */
    //to get string names from rgb values
    
    func hexStringFromColor(_ color: UIColor) -> String {
        
        let components = color.cgColor.components
        let r: CGFloat = components![0]
        let g: CGFloat = components![1]
        let b: CGFloat = components![2]
        let rr = lround(Double(r) * 255.0)
        let gr = lround(Double(g) * 255.0)
        let br = lround(Double(b) * 255.0)
        //        return "\(rr)\(gr)\(br)"
        return String(format: "%02lX%02lX%02lX",rr,gr,br)
        //return "\(lroundf(r * CGFloat("255")))" + "\(lroundf(g * 255))" + "\(lroundf(b * 255))"
        //return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        //        return ""
    }
    
    func getMakeDetails(_ object: AnyObject) {
        
        let makeDetails = object as? VehicleMakeBO
        self.vehicleBO?.vehicleMake = makeDetails?.vehicleMakeName as? String
        vehicleMakeTextField.text = self.vehicleBO?.vehicleMake
    }
    
    func getVehicleMakeDetails(_ object: AnyObject){
        self.vehicleBO?.vehicleMake = object as? String
        vehicleMakeTextField.text = self.vehicleBO?.vehicleMake
    }
    
    func getScannedObject(_ object: AnyObject) {
        
        let vehicleInfoBO: VehicleDetailsBO = object as! VehicleDetailsBO
        //        vehicleInfoBO.vehicleColor = ""
        self.vehicleBO = vehicleInfoBO
        
        //        self.getSelectedColor(100)
        self.updateDetailsFromResponses(self.vehicleBO!)
        //        self.updateSwitchStatusByModel()
        self.oversizeSwitch.setOn((self.vehicleBO?.isOversized)!, animated: true)
    }
    
    //    func getScannedObjectByTag(object: AnyObject) {
    //
    //        let vehicleInfoBO: VehicleDetailsBO = object as! VehicleDetailsBO
    //        self.vehicleBO?.damageMarksArray = vehicleInfoBO.damageMarksArray
    //        self.vehicleBO?.licenseNumber = vehicleInfoBO.licenseNumber
    //        self.vehicleBO?.lastUpdated = vehicleInfoBO.lastUpdated
    //
    //        self.getSelectedColor(100)
    //        self.updateDetailsFromResponses(self.vehicleBO!)
    //        self.oversizeSwitch.setOn((self.vehicleBO?.isOversized)!, animated: true)
    //    }
    
    func getModelDetails(_ object: AnyObject) {
        
        self.vehicleBO?.vehicleModel = object as? String
        self.vehicleModelTextField.text = self.vehicleBO?.vehicleModel
        self.updateSwitchStatusByModel()
    }
    
    @IBAction func modelButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let multipleTicketViewController = mainStroyboard.instantiateViewController(withIdentifier: "MultipleTicketsViewController") as? MultipleTicketsViewController
        multipleTicketViewController?.delegate = self
        
        let modelArray = ["AWD/4WD", "Convertible", "Coupe", "Hatchback", "Hybrid/Electric", "Luxury", "Sedan", "SUV/CrossOver", "Truck", "Van/Minivan", "Wagon"]
        multipleTicketViewController!.modelArray = modelArray as NSArray
        naviController?.pushViewController(multipleTicketViewController!, animated: true)
    }
    
    @IBAction func saveVehicleInfo(_ sender: AnyObject) {
        
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow) {
            
            if ((self.vehicleBO?.vehicleVIN) != nil && self.vehicleBO?.vehicleVIN?.characters.count > 0) {
                
                //                if (self.vehicleBO != nil) || self.licenceTagTextField.text?.characters.count > 0 {
                
                self.vehicleBO?.licenseNumber = self.licenceTagTextField.text
                naviController?.vehicleDetails = self.vehicleBO
                naviController?.isOversizeVehicle = self.oversizeSwitch.isOn
                ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle info successfully saved"), logType: "Normal")
                _ = naviController?.popViewController(animated: true)
                //                }
            } else {
                //                if (self.vehicleBO != nil) || self.licenceTagTextField.text?.characters.count > 0 {
                
                self.vehicleBO?.licenseNumber = self.licenceTagTextField.text
                naviController?.vehicleDetails = self.vehicleBO
                naviController?.isOversizeVehicle = self.oversizeSwitch.isOn
                ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle info successfully saved"), logType: "Normal")
                _ = naviController?.popViewController(animated: true)
                //                }
            }
            
        } else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow) {
            
            //            if naviController?.ticketBO?.vehicleDetails?.vehicleVIN?.characters.count > 0 && naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count > 0 {
            //
            //                self.vehicleBO?.licenseNumber = self.licenceTagTextField.text
            //                naviController?.ticketBO?.color = self.vehicleBO?.vehicleColor
            //                naviController?.ticketBO?.model = self.vehicleBO?.vehicleModel
            //                naviController?.ticketBO?.make = self.vehicleBO?.vehicleMake
            //                naviController?.ticketBO?.licenseTag = self.vehicleBO?.licenseNumber
            //                naviController?.ticketBO?.vehicleDetails = self.vehicleBO
            //                naviController?.ticketBO?.oversized = self.oversizeSwitch.on
            //                ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle info updated successfully"), logType: "Normal")
            //                naviController?.popViewControllerAnimated(true)
            //
            //            } else {
            self.vehicleBO?.licenseNumber = self.licenceTagTextField.text
            //                naviController?.ticketBO?.color = self.vehicleBO?.vehicleColor
            //                naviController?.ticketBO?.model = self.vehicleBO?.vehicleModel
            //                naviController?.ticketBO?.make = self.vehicleBO?.vehicleMake
            //                naviController?.ticketBO?.licenseTag = self.vehicleBO?.licenseNumber
            naviController?.ticketBO?.vehicleDetails = self.vehicleBO
            naviController?.ticketBO?.vehicleDetails?.isOversized = self.oversizeSwitch.isOn
            ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle info updated successfully"), logType: "Normal")
            _ = naviController?.popViewController(animated: true)
            //            }
        }
    }
    
    @IBAction func cancelVehicleInfo(_ sender: AnyObject) {
        ActivityLogsManager.sharedInstance.logUserActivity(("Vehicle info is not saved"), logType: "Normal")
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
    
    // MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "VehicleMake" {
            let vehicleMakeViewController = segue.destination as! VehicleMakeViewController
            vehicleMakeViewController.delegate = self
        }
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kVehicleInfoByVIN as String:
            //            _ = naviController?.popViewController(animated: true)
//            ActivityLogsManager.sharedInstance.logUserActivity(("successful scan of vin number : " + self.VINNumber), logType: "Normal")
            self.getScannedObject(response)
            
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
