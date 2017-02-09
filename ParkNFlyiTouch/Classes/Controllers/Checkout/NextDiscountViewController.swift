//
//  NextDiscountViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/3/15.
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


class NextDiscountViewController: BaseViewController {
    
    @IBOutlet weak var balanceDueLabel: UILabel!
    @IBOutlet weak var discountTextField: TextField!
    
    var ticketBO:TicketBO?
    var updatedTicketBO:TicketBO?
    var selectedDiscountsArray: [DiscountInfoBO]?
    var validatedDiscountsArray: [DiscountInfoBO]?
    var BalanceDue: String!
    var cardType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedDiscountsArray = [DiscountInfoBO]()
        self.validatedDiscountsArray = [DiscountInfoBO]()
        self.updatedTicketBO = TicketBO()
        
        if ticketBO != nil {
            updatedTicketBO = ticketBO
        }
        self.updateIdentifierKeyWithCAPOrAAA()
        
        if let _ = ticketBO?.discounts {
            for discount in (ticketBO?.discounts)! {
                self.selectedDiscountsArray?.append(discount as! DiscountInfoBO)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.discountTextField.text = ""
        
        if ticketBO != nil {
            self.callCalculateRateMethod(ticketBO!)
        }
    }
    
    func updateIdentifierKeyWithCAPOrAAA(){
        
        if naviController?.ticketBO?.identifierKey != "" {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let validateDiscountCardTypeManager:ValidateCardTypeEncryptedNumberService = ValidateCardTypeEncryptedNumberService()
            validateDiscountCardTypeManager.delegate = self
            let encryptedIdentifierKey = Encryptor.encrypt((naviController?.ticketBO?.identifierKey)!)
            validateDiscountCardTypeManager.validateCardTypeEncryptedNumberWebService(kValidateCardTypeEncryptedNumberForIdentifier, parameters: ["IdentifierKey": encryptedIdentifierKey])
        }
    }
    
    func updateDetailsFromResponses(_ calculateRateDict: NSDictionary) {
        
        self.BalanceDue = calculateRateDict.getInnerText(forKey: "a:TotalCharge")
        self.balanceDueLabel.text = "Balance Due: " + "$ " + calculateRateDict.getInnerText(forKey: "a:TotalCharge") as String + ""
    }
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        
        for viewController in (naviController?.viewControllers)! {
            if viewController.isKind(of: CheckOutViewController.self) {
                _ = naviController?.popToViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func applyDiscountButtonAction(_ sender: AnyObject) {
        
        if self.BalanceDue != "0" || self.BalanceDue != "0.00" {
            if (self.discountTextField.text != "") {
                self.searchOrScanDiscountMethod(self.discountTextField.text!)
                
            }else {
                let alert = UIAlertController(title: klAlert, message: klPleaseGiveValidInputs, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: kAlert, message: (kAmountZero as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func scanDiscountButtonAction(_ sender: AnyObject) {
        
    }
    
    func searchOrScanDiscountMethod(_ discountCode: String) {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let validateDiscountCardTypeManager:ValidateCardTypeEncryptedNumberService = ValidateCardTypeEncryptedNumberService()
        validateDiscountCardTypeManager.delegate = self
        let encryptedIdentifierKey = Encryptor.encrypt(discountCode)
        validateDiscountCardTypeManager.validateCardTypeEncryptedNumberWebService(kValidateCardTypeEncryptedNumber, parameters: ["IdentifierKey": encryptedIdentifierKey])
    }
    
    
    func searchDiscountByCardNumber(_ discountCode: String, discountCardType: String) {
        
        if discountCardType == kAAA {
            if self.cardType == discountCardType {
                naviController?.ticketBO?.identifierKey = discountCode
            }
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let allDiscountsFromClubCodeManager:GetDiscountsFromClubCodeService = GetDiscountsFromClubCodeService()
            allDiscountsFromClubCodeManager.delegate = self
            allDiscountsFromClubCodeManager.getDiscountsFromClubCodeWebservice(kGetDiscountsFromClubCode, parameters: ["DiscountCode": discountCode, "PARKINGTYPE": (ticketBO?.parkingType)!])
            
        } else if discountCardType == kCAP {
            if self.cardType == discountCardType {
                naviController?.ticketBO?.identifierKey = discountCode
            }
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let discountByCAPCodeManager:GetDiscountsAssociatedWithLoyaltyService = GetDiscountsAssociatedWithLoyaltyService()
            discountByCAPCodeManager.delegate = self
            discountByCAPCodeManager.getDiscountsAssociatedWithLoyaltyWebService(kGetDiscountsAssoicatedWithLoyalty, parameters: ["DiscountCode": discountCode, "PARKINGTYPE": (ticketBO?.parkingType)!])
            
        }else {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let allDiscountsByNameOrBarcodeManager:GetDiscountsByBarcodeOrNameService = GetDiscountsByBarcodeOrNameService()
            allDiscountsByNameOrBarcodeManager.delegate = self
            allDiscountsByNameOrBarcodeManager.getDiscountsByBarcodeOrNameWebservice(kGetDiscountsByBarcodeOrName, parameters:["DiscountCode": discountCode, "PARKINGTYPE": (ticketBO?.parkingType)!])
        }
    }
    
    @IBAction func payWithCCButtonAction(_ sender: AnyObject) {
        //display paywithcc view controller
        let checkOutStroyboardId = Utility.createStoryBoardid(kCheckOut)
        let payWithCCViewController = checkOutStroyboardId.instantiateViewController(withIdentifier: "PayWithCCViewController") as! PayWithCCViewController
        naviController?.pushViewController(payWithCCViewController, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func callCalculateRateMethod (_ updatedTicketBO:TicketBO) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let calculateRateManager:CalculateRateService = CalculateRateService()
        calculateRateManager.delegate = self
        calculateRateManager.calculateRateWebService(kCalculateRate, parameters:["TicketDetails": ticketBO!])
    }
    
    func callValidateDiscountMethod(_ selectedDiscountsArray:[DiscountInfoBO]){
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let validateDiscountRulesManager:ValidateDiscountRulesService = ValidateDiscountRulesService()
        validateDiscountRulesManager.delegate = self
        validateDiscountRulesManager.validateDiscountRulesWebService(kValidateDiscountsRules, parameters:["SelectedDiscountArray": selectedDiscountsArray])
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
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch identifier {
            
        case kValidateCardTypeEncryptedNumberForIdentifier as String:
            
            let responseDict:NSDictionary = response as! NSDictionary
            self.cardType = responseDict.getStringFromDictionary(withKeys: ["ValidateCardTypeEncryptedNumberResponse","ValidateCardTypeEncryptedNumberResult"]) as String
            
            break
            
        case kCalculateRate as String:
            let calculateRateDict: NSDictionary = response as! NSDictionary
            self.updateDetailsFromResponses(calculateRateDict)
            
            break
            
        case kValidateCardTypeEncryptedNumber as String:
            
            let responseDict:NSDictionary = response as! NSDictionary
            let discountCode = self.discountTextField.text
            let resultString = responseDict.getStringFromDictionary(withKeys: ["ValidateCardTypeEncryptedNumberResponse","ValidateCardTypeEncryptedNumberResult"]) as String
            self.searchDiscountByCardNumber(discountCode!, discountCardType: resultString)
            
            break
            
        case kValidateDiscountsRules as String:
            
            self.validatedDiscountsArray = response as? [DiscountInfoBO]
            naviController?.ticketBO?.discounts = NSMutableArray(array: self.validatedDiscountsArray!)
            self.updatedTicketBO?.discounts = NSMutableArray(array: self.validatedDiscountsArray!)
            self.callCalculateRateMethod(self.updatedTicketBO!)
            
            break
            
        case kGetDiscountsByBarcodeOrName as String:
            let discountArrayByBarcode = response as? [DiscountInfoBO]
            for discount in discountArrayByBarcode! {
                self.selectedDiscountsArray?.append(discount)
            }
            self.callValidateDiscountMethod(self.selectedDiscountsArray!)
            
            break
            
        case kGetDiscountsFromClubCode as String:
            let discountsByAAACard = response as? [DiscountInfoBO]
            if self.selectedDiscountsArray?.count > 0 {
                
                for aaaDiscount in discountsByAAACard! {
                    
                    var isAlreadyExist = false
                    
                    for discount in self.selectedDiscountsArray! {
                        if discount.discountCode == aaaDiscount.discountCode {
                            isAlreadyExist = true
                            break
                        }
                    }
                    if !isAlreadyExist {
                        self.selectedDiscountsArray?.append(aaaDiscount)
                    }
                }
                
            }else {
                for aaaDiscount in discountsByAAACard! {
                    self.selectedDiscountsArray?.append(aaaDiscount)
                }
            }
            self.callValidateDiscountMethod(self.selectedDiscountsArray!)
            self.updateIdentifierKeyWithCAPOrAAA()
            
            break
            
        case kGetDiscountsAssoicatedWithLoyalty as String:
            
            let discountsByCAPCard = response as? [DiscountInfoBO]
            if self.selectedDiscountsArray?.count > 0 {
                
                for capDiscount in discountsByCAPCard! {
                    
                    var isAlreadyExist = false
                    
                    for discount in self.selectedDiscountsArray! {
                        if discount.discountCode == capDiscount.discountCode {
                            isAlreadyExist = true
                            break
                        }
                    }
                    if !isAlreadyExist {
                        self.selectedDiscountsArray?.append(capDiscount)
                    }
                }
                
            }else {
                for capDiscount in discountsByCAPCard! {
                    self.selectedDiscountsArray?.append(capDiscount)
                }
            }
            
            self.updateIdentifierKeyWithCAPOrAAA()
            self.callValidateDiscountMethod(self.selectedDiscountsArray!)
            
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
