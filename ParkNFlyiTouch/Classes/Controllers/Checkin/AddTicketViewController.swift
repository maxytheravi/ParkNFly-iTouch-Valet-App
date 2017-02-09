//
//  AddTicketViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 24/02/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class AddTicketViewController: BaseViewController {
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var preprintedTicketTextField: TextField!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Add Ticket"
        self.connectionStatusUpdate((naviController?.dtdev?.connstate)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        naviController!.dtdev!.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        naviController!.dtdev!.disconnect()
    }
    
    // MARK: - IPC Machine Methods
    override func scannedBarcodeData(_ barcode: String!) {
        
        if Utility.checkForPreprintedNumberIsValid(barcode) == true {
            
            self.preprintedTicketTextField.text = barcode
            self.callValidateNumberService()
            ActivityLogsManager.sharedInstance.logUserActivity(("Scanned Pre-printed number: " + barcode), logType: "Normal")
            
        } else {
            
            let alert = UIAlertController(title: klError, message: "Invalid input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            ActivityLogsManager.sharedInstance.logUserActivity(("Invalid Pre-printed number : " + self.preprintedTicketTextField.text!), logType: "Normal")
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
    
    //MARK: UITextField Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if Utility.checkForPreprintedNumberIsValid(self.preprintedTicketTextField.text!) == true {
            
            self.callValidateNumberService()
            
        } else {
            
            let alert = UIAlertController(title: klError, message: "Invalid input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return true
    }
    
    //MARK: Button Clicked
    @IBAction func getTicketFromServerButtonAction(_ sender: AnyObject) {
        self.getTicketFromServerAPICall()
        ActivityLogsManager.sharedInstance.logUserActivity(("Get ticket from server button called"), logType: "Normal")
    }
    
    //MARK: Custom Methods
    func getTicketFromServerAPICall() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let serviceManager: GetTicketFromServerService = GetTicketFromServerService()
        serviceManager.delegate = self
        serviceManager.getTicketFromServerService(kGetTicketFromServer, parameters: ["DeviceCode": (naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode)!])
    }
    
    // MARK: - WebService calls
    func callValidateNumberService() {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let serviceManager: ValidateNumberService = ValidateNumberService()
        serviceManager.delegate = self
        serviceManager.validateNumberWebService(kValidateNumberService, parameters: ["PriprintedNumber": self.preprintedTicketTextField.text!])
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kGetTicketFromServer as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            
            naviController?.priprintedNumber = responseDict.getInnerText(forKey: "a:Barcode")
            naviController?.ticketFromServerPrintDateTime = Utility.getFormatedDateTimeWithT(responseDict.getInnerText(forKey: "a:PrintDateTime"))
            
            naviController?.ticketFromServerTicketID = responseDict.getInnerText(forKey: "a:TicketID")
            naviController?.isTicketFromServer = true
            ActivityLogsManager.sharedInstance.logUserActivity(("Successfully fetched next ticket from server : " +  (naviController?.priprintedNumber!)!), logType: "Normal")
            _ = naviController?.popViewController(animated: true)
            
            break
            
        case kValidateNumberService as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            
            if responseDict.getStringFromDictionary(withKeys: ["ValidateNumberResponse","ValidateNumberResult","a:Result"]) as NSString == "true" {
                naviController?.priprintedNumber = self.preprintedTicketTextField.text
                naviController?.isTicketFromServer = false
//                ActivityLogsManager.sharedInstance.logUserActivity(("valid pre-printed number : " + (naviController?.priprintedNumber!)!), logType: "Normal")
                _ = naviController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: klError, message:"Preprinted number is not usable", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
//                ActivityLogsManager.sharedInstance.logUserActivity(("Invalid pre-printed number : " + self.preprintedTicketTextField.text!), logType: "Normal")
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
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
