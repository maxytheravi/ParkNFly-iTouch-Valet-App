//
//  PayWithCCViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/4/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class PayWithCCViewController: BaseViewController, ActionsheetManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var expiryYearTextField: UITextField!
    @IBOutlet weak var balanceDueLabel: UILabel!
    @IBOutlet weak var expiryMonthTextField: UITextField!
    @IBOutlet weak var creditCardType: UITextField!
    @IBOutlet weak var creditCardNumberTextField: UITextField!
    
    var calculateRateDict: NSDictionary?
    var paymentResponseDict: NSDictionary?
    var creditCardInfoBO: CreditCardInfoBO?
    var cardTypes: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardTypes = ["AMEX","Visa","MasterCard","Discover","Diners","OTHER"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(PayWithCCViewController.textFieldTextChanged(_:)), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        clearData()
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let calculateRateManager:CalculateRateService = CalculateRateService()
        calculateRateManager.delegate = self
        calculateRateManager.calculateRateWebService(kCalculateRate, parameters:["TicketDetails": (naviController?.ticketBO)!])
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let updateValetInfoForTabletManager:UpdateValetInfoForTabletService = UpdateValetInfoForTabletService()
        updateValetInfoForTabletManager.delegate = self
        updateValetInfoForTabletManager.updateValetInfoForTabletWebService(kUpdateValetInfoForTablet, parameters:["Ticket": (naviController?.ticketBO)!])
        
        if naviController?.ticketBO?.identifierKey != nil {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let creditCardInfoManager:GetCreditCardAssociatedWithFPService = GetCreditCardAssociatedWithFPService()
            creditCardInfoManager.delegate = self
            creditCardInfoManager.getCreditCardAssociatedWithFPNoWebService(kGetCreditCardAssociatedWithFP, parameters:["FPCardNumber": (naviController?.ticketBO?.identifierKey)!])
        }
    }
    
    func clearData(){
        self.creditCardNumberTextField.text = ""
        self.creditCardType.text = ""
        self.expiryMonthTextField.text = ""
        self.expiryYearTextField.text = ""
    }
    
    func updateDetailsFromResponses(_ calculateRateDict: NSDictionary) {
        self.balanceDueLabel.text = "Balance Due: $ " + calculateRateDict.getInnerText(forKey: "a:TotalCharge") as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTextFieldsWithData(_ creditCardInfoDict: CreditCardInfoBO) {
        
        self.creditCardNumberTextField.text = creditCardInfoDict.cardNumber
        self.expiryMonthTextField.text = creditCardInfoDict.expiryMonth
        self.expiryYearTextField.text = creditCardInfoDict.expiryYear
        self.creditCardType.text = creditCardInfoDict.cardType
    }
    
    // MARK: UIButton action
    /**
    This method will show UIAlertController for select credit card type
    
    :param: sender  The object that triggered the action
    :returns: Void returns nothing
    */
    
    @IBAction func selectCardTypeButtonAction(_ sender: AnyObject) {
        //display credit card type options popover
        self.view.endEditing(true)
        
        let actionsheetView = ActionsheetObject()
        actionsheetView.delegate = self
        actionsheetView.createActionsheet(self.cardTypes as! [AnyObject], identifier: kCreditCardTypeActionSheet)
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: ActionsheetManagerDelegate methods
    func getActionsheet(_ optionMenu:UIAlertController) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func getCreditCardFromActionsheet(_ selectedOption:String) {
        self.creditCardType.text = selectedOption
    }
    
    // MARK: Functional Methods
    func validateSearch() -> Bool {
        
        if self.creditCardNumberTextField.text == "" || self.expiryMonthTextField.text == "" || self.expiryYearTextField.text == "" || self.creditCardType.text == "" {
            return false
        }
        return true
    }

    
    @IBAction func makePaymentButtonAction(_ sender: AnyObject) {
        
        if self.validateSearch() {
        let parameterDict: NSMutableDictionary = NSMutableDictionary()
        parameterDict["TicketDetails"] = naviController?.ticketBO
        parameterDict["CalculateDetails"] = self.calculateRateDict!
        
        if let _ = self.creditCardInfoBO {
            parameterDict["CreditCardInfoBO"] = self.creditCardInfoBO
        } else {
            parameterDict["CreditCardNumber"] = creditCardNumberTextField.text!
            parameterDict["CCMonth"] = self.expiryMonthTextField.text!
            parameterDict["CCYear"] = self.expiryYearTextField.text!
            parameterDict["CreditCardType"] = self.creditCardType.text!
            
        }
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let loadPaymentDetailsManager:PaymentProcessService = PaymentProcessService()
        loadPaymentDetailsManager.delegate = self
        loadPaymentDetailsManager.paymentProcessWebService(kProcessPayment, parameters: parameterDict)
            
        } else {
            let alert = UIAlertController(title: kAlert, message: (klPleaseGiveValidInputs as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
//        let fileLocation = NSBundle.mainBundle().pathForResource("textFile1", ofType: "txt")!
//        let text : String
//        do {
//            text = try String(contentsOfFile: fileLocation)
//        } catch {
//            text = ""
//        }
//        
//        let responseObject:NSData = text.dataUsingEncoding(NSUTF8StringEncoding)!
//        let receiptData: NSMutableDictionary = NSMutableDictionary(dictionary: GenericXmlParser.dictionaryForXMLData(responseObject))
//        
//        receiptData["address"] = naviController?.facilityConfig?.webAddress
//        receiptData["phone"] = naviController?.facilityConfig?.phone
//        receiptData["facilityName"] = naviController?.facilityConfig?.facilityName
//        receiptData["cashierName"] = naviController?.userName
//        if let _ = naviController?.shiftCode {
//            receiptData["shiftCode"] = naviController?.shiftCode
//        }
//        
//        self.loadReceipt(receiptData)
    }
    
    func loadReceipt(_ receiptData: NSMutableDictionary) {
        
        let checkOutStroyboardId = Utility.createStoryBoardid(kCheckOut)
        let dynamicReceipt = checkOutStroyboardId.instantiateViewController(withIdentifier: "DynamicReceipt") as! DynamicReceipt
        dynamicReceipt.receiptData = receiptData as [NSObject : AnyObject]
        naviController?.pushViewController(dynamicReceipt, animated: true)
    }
    
    @IBAction func cancelPaymentButtonAction(_ sender: AnyObject) {
        _ = naviController?.popViewController(animated: true)
    }
    
    // MARK: - TextField Delegates
    func textFieldTextChanged(_ sender : AnyObject) {
        self.creditCardInfoBO = nil
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch identifier {
            
        case kCalculateRate as String:
            self.calculateRateDict = response as? NSDictionary
            self.updateDetailsFromResponses(self.calculateRateDict!)
            
            break
            
        case kGetCreditCardAssociatedWithFP as String:
            self.creditCardInfoBO = response as? CreditCardInfoBO
            if let _ = self.creditCardInfoBO {
                self.showTextFieldsWithData(self.creditCardInfoBO!)
            }
            
        case kUpdateValetInfoForTablet as String:
            _ = response as? NSDictionary
            break
        case kProcessPayment as String:
            
            var receiptData: NSMutableDictionary = NSMutableDictionary()
            if let receiptResult = (response as! NSDictionary).getObjectFromDictionary(withKeys: ["PaymentProcessResponse","PaymentProcessResult","a:Result"]) {
                receiptData = ["GetPaymentReceiptResponse":["GetPaymentReceiptResult":receiptResult]]
            }
            
            receiptData["address"] = naviController?.facilityConfig?.webAddress
            receiptData["phone"] = naviController?.facilityConfig?.phone
            receiptData["facilityName"] = naviController?.facilityConfig?.facilityName
            receiptData["cashierName"] = naviController?.userName
            if let _ = naviController?.shiftCode {
                receiptData["shiftCode"] = naviController?.shiftCode
            }
            
            self.loadReceipt(receiptData)
            
            break
            
        default:
            break
        }
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        
        if identifier as String != kGetCreditCardAssociatedWithFP {
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
