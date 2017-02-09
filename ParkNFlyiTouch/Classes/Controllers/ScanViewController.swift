
//
//  ScanViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 11/19/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol ScanViewControllerDelegate {
    
    @objc optional func getScannedObject(_ object: AnyObject)
}

class ScanViewController: BaseViewController {
    
    @IBOutlet weak var scanDetailTextField: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    @IBOutlet weak var preprintedTicketTextfield: TextField!
    
    var scanType: ScanType?
    
    var priPrintedNumber: String = ""
    var VINNumber: String = ""
    var priPrintedNumberForLookup: String = ""
    
    var delegate: ScanViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Scan"
        if self.scanType == ScanType.kVINNumber {
            self.scanDetailTextField.text = "Scan VIN to begin"
            self.preprintedTicketTextfield.placeholder = "VIN number #"
        }
        
        self.connectionStatusUpdate((naviController?.dtdev?.connstate)!)
        
        //        self.scannedBarcodeData("1J4GW58S1XC675729")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        naviController!.dtdev!.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        naviController!.dtdev!.disconnect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if arch(i386) || arch(x86_64)
            //            if self.scanType == ScanType.kPreprintedTicket {
            //                self.priPrintedNumber = "MIA0-000-080"
            //                self.callValidateNumberService()
            //            } else if self.scanType == ScanType.kVINNumber {
            //                self.VINNumber = self.validateVINNumber("5N1BA0ND8CN600396")
            //                self.callVINService()
            //            } else if self.scanType == ScanType.kPreprintedTicketForLookup {
            //                self.priPrintedNumberForLookup = "MIA0-000-080"
            //                self.callTicketDetailsByBarcodeService()
            //            }
            if self.scanType == ScanType.kPreprintedTicket {
                self.preprintedTicketTextfield.text = "MIA0-000-048"
            } else if self.scanType == ScanType.kVINNumber {
                self.preprintedTicketTextfield.text = self.validateVINNumber("2HGFG3B83CH566178")
            } else if self.scanType == ScanType.kPreprintedTicketForLookup {
                self.preprintedTicketTextfield.text = "MIA0-000-048"
            }
        #endif
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
        
        if self.scanType == ScanType.kPreprintedTicket {
            self.priPrintedNumber = barcode
            self.callValidateNumberService()
            ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Pre-printed/Ticket barcode number: " + barcode), logType: "Normal")
        } else if self.scanType == ScanType.kVINNumber {
            self.VINNumber = self.validateVINNumber(barcode)
            self.callVINService()
            ActivityLogsManager.sharedInstance.logUserActivity(("Scanned VIN number: " + barcode), logType: "Normal")
        } else if self.scanType == ScanType.kPreprintedTicketForLookup {
            
            if !barcode.contains("-") && barcode.characters.count >= 17 {
                self.VINNumber = barcode
                self.callTicketDetailsByBarcodeServiceThroughVIN()
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned VIN number: " + barcode), logType: "Normal")
            } else {
                self.priPrintedNumberForLookup = barcode
                self.callTicketDetailsByBarcodeService()
                ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Pre-printed/Ticket barcode number: " + barcode), logType: "Normal")
            }
            
            //            self.priPrintedNumberForLookup = barcode
            //            self.callTicketDetailsByBarcodeService()
            //            ActivityLogsManager.sharedInstance.logUserActivity(("Pre-printed/ Ticket barcode number scanned : " + barcode), logType: "Normal")
        }
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
    func callValidateNumberService() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let serviceManager: ValidateNumberService = ValidateNumberService()
        serviceManager.delegate = self
        serviceManager.validateNumberWebService(kValidateNumberService, parameters: ["PriprintedNumber": self.priPrintedNumber])
    }
    
    func callVINService() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getVehicleInfoByVINService: GetVehicleInfoByVINService = GetVehicleInfoByVINService()
        getVehicleInfoByVINService.delegate = self
        getVehicleInfoByVINService.getVehicleInfoByVINService(kVehicleInfoByVIN, parameters:["VIN": self.VINNumber])
    }
    
    func callTicketDetailsByBarcodeService() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getTicketByBarcodeService: GetTicketByBarcodeService = GetTicketByBarcodeService()
        getTicketByBarcodeService.delegate  = self
        getTicketByBarcodeService.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["TicketNumber": self.priPrintedNumberForLookup])
    }
    
    func callTicketDetailsByBarcodeServiceThroughVIN() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getTicketByBarcodeService: GetTicketByBarcodeService = GetTicketByBarcodeService()
        getTicketByBarcodeService.delegate  = self
        getTicketByBarcodeService.getTicketByBarcodeWebService(kGetTicketByBarcode, parameters: ["VIN": self.VINNumber])
    }
    
    // MARK: - Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        if self.scanType == ScanType.kPreprintedTicket {
            self.priPrintedNumber = textField.text!
            self.callValidateNumberService()
            ActivityLogsManager.sharedInstance.logUserActivity(("Searched using pre-printed/Ticket barcode  number : " + textField.text!), logType: "Normal")
        } else if self.scanType == ScanType.kVINNumber {
            self.VINNumber = self.validateVINNumber(textField.text)
            self.callVINService()
            ActivityLogsManager.sharedInstance.logUserActivity(("Searched using VIN number : " + textField.text!), logType: "Normal")
        } else if self.scanType == ScanType.kPreprintedTicketForLookup {
            
            if !textField.text!.contains("-") && textField.text!.characters.count >= 17 {
                self.VINNumber = textField.text!
                self.callTicketDetailsByBarcodeServiceThroughVIN()
                ActivityLogsManager.sharedInstance.logUserActivity(("Searched using VIN number : " + textField.text!), logType: "Normal")
            } else {
                self.priPrintedNumberForLookup = textField.text!
                self.callTicketDetailsByBarcodeService()
                ActivityLogsManager.sharedInstance.logUserActivity(("Searched using pre-printed/ Ticket barcode  number : " + textField.text!), logType: "Normal")
            }
            
            //            self.priPrintedNumberForLookup = textField.text!
            //            self.callTicketDetailsByBarcodeService()
            //            ActivityLogsManager.sharedInstance.logUserActivity(("Searched for pre-printed/ Ticket barcode  number : " + textField.text!), logType: "Normal")
        }
        
        return true
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kValidateNumberService as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            
            if responseDict.getStringFromDictionary(withKeys: ["ValidateNumberResponse","ValidateNumberResult","a:Result"]) as NSString == "true" {
                naviController?.priprintedNumber = self.priPrintedNumber
                naviController?.isTicketFromServer = false
                //                ActivityLogsManager.sharedInstance.logUserActivity(("valid pre-printed number : " + (naviController?.priprintedNumber!)!), logType: "Normal")
                _ = naviController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: klError, message:"Preprinted number is not usable", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                //                ActivityLogsManager.sharedInstance.logUserActivity(("Invalid pre-printed number : " + self.preprintedTicketTextfield.text!), logType: "Normal")
            }
            
            break
            
        case kVehicleInfoByVIN as String:
            
            _ = naviController?.popViewController(animated: true)
            //            ActivityLogsManager.sharedInstance.logUserActivity(("successful scan of vin number : " + self.VINNumber), logType: "Normal")
            self.delegate?.getScannedObject!(response)
            
            break
            
        case kGetTicketByBarcode as String:
            
            naviController?.ticketBO = response as? TicketBO
            naviController?.updateDetailsFromTicketBO(naviController?.ticketBO)
            //            ActivityLogsManager.sharedInstance.logUserActivity(("successful scan of ticket number : " + (naviController?.ticketBO?.barcodeNumberString)!), logType: "Normal")
            self.popLookupViewControllerAnimated(true)
            
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
