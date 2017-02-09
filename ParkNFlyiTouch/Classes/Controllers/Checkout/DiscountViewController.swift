
//
//  DiscountViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/9/15.
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


class DiscountViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, AvailableDiscountsTableViewCellDelegate, SelectedDiscountTableViewCellDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var discountNumberTextField: TextField!
    
    var discountsArray:[DiscountInfoBO]?
    var selectedDiscountArray:[DiscountInfoBO]?
    var validatedDiscountsArray: [DiscountInfoBO]?
    var cardType: String?
    
    @IBOutlet weak var discountTableView: UITableView!
    @IBOutlet weak var selectedDiscountTableview: UITableView!
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.discountTableView.layer.borderWidth = 2.0
        self.discountTableView.layer.cornerRadius = 0
        self.discountTableView.layer.masksToBounds = true
        self.discountTableView.layer.borderColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor
        self.discountTableView.allowsSelection = false
        
        self.selectedDiscountTableview.layer.borderWidth = 2.0
        self.selectedDiscountTableview.layer.cornerRadius = 0
        self.selectedDiscountTableview.layer.masksToBounds = true
        self.selectedDiscountTableview.layer.borderColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor
        self.selectedDiscountTableview.allowsSelection = false
        
        self.discountsArray = [DiscountInfoBO]()
        self.selectedDiscountArray = [DiscountInfoBO]()
        self.validatedDiscountsArray = [DiscountInfoBO]()
        
        self.updateIdentifierKeyWithCAPOrAAA()
        
        if let _ = naviController?.ticketBO?.discounts {
            for discount in (naviController?.ticketBO?.discounts)! {
                self.selectedDiscountArray?.append(discount as! DiscountInfoBO)
            }
        }
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            ticketNumberLabel.text = (naviController?.ticketBO?.prePrintedTicketNumber)! as String
        }else {
            ticketNumberLabel.text = (naviController?.ticketBO?.barcodeNumberString)! as String
        }
        let allDiscountsManager:GetAvailableDiscountsService = GetAvailableDiscountsService()
        allDiscountsManager.delegate = self
        allDiscountsManager.getAvailableDiscountsWebservice(kGetAvailableDiscounts, parameters:["PARKINGTYPE": (naviController?.ticketBO?.parkingType)!])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.discountNumberTextField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func scanDiscountButtonAction(_ sender: AnyObject) {
    }
    
    @IBAction func saveDiscountButtonAction(_ sender: AnyObject) {
        self.discountNumberTextField.text = ""
        var selecedDiscountsByUser = [DiscountInfoBO]()
        
        for discounts in self.selectedDiscountArray! {
            if discounts.isSwitchOn == true {
                selecedDiscountsByUser.append(discounts)
            }
        }
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let validateDiscountRulesManager:ValidateDiscountRulesService = ValidateDiscountRulesService()
        validateDiscountRulesManager.delegate = self
        validateDiscountRulesManager.validateDiscountRulesWebService(kValidateDiscountsRules, parameters:["SelectedDiscountArray": selecedDiscountsByUser])
        
    }
    
    @IBAction func searchDiscountButtonAction(_ sender: AnyObject) {
        
        if (self.discountNumberTextField.text != "") {
            self.searchOrScanDiscountMethod(self.discountNumberTextField.text!)
        } else {
            let alert = UIAlertController(title: klAlert, message: klPleaseGiveValidInputs, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
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
            allDiscountsFromClubCodeManager.getDiscountsFromClubCodeWebservice(kGetDiscountsFromClubCode, parameters: ["DiscountCode": discountCode, "PARKINGTYPE": (naviController?.ticketBO?.parkingType)!])
            
        } else if discountCardType == kCAP {
            if self.cardType == discountCardType {
                naviController?.ticketBO?.identifierKey = discountCode
            }
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let discountByCAPCodeManager:GetDiscountsAssociatedWithLoyaltyService = GetDiscountsAssociatedWithLoyaltyService()
            discountByCAPCodeManager.delegate = self
            discountByCAPCodeManager.getDiscountsAssociatedWithLoyaltyWebService(kGetDiscountsAssoicatedWithLoyalty, parameters: ["DiscountCode": discountCode, "PARKINGTYPE": (naviController?.ticketBO?.parkingType)!])
            
        }else {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let allDiscountsByNameOrBarcodeManager:GetDiscountsByBarcodeOrNameService = GetDiscountsByBarcodeOrNameService()
            allDiscountsByNameOrBarcodeManager.delegate = self
            allDiscountsByNameOrBarcodeManager.getDiscountsByBarcodeOrNameWebservice(kGetDiscountsByBarcodeOrName, parameters:["DiscountCode": discountCode, "PARKINGTYPE": (naviController?.ticketBO?.parkingType)!])
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == discountTableView {
            return ((self.discountsArray?.count)! as Int)
        } else {
            return ((self.selectedDiscountArray?.count)! as Int)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == discountTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableDiscountsCell") as! AvailableDiscountsTableViewCell
            cell.delegate = self
            if let discountBO = self.discountsArray?[(indexPath as NSIndexPath).row] {
                cell.configureCell(discountBO, forIndexPath: (indexPath as NSIndexPath).row)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedDiscounts") as! SelectedDiscountTableViewCell
            let discountBO:DiscountInfoBO = self.selectedDiscountArray![(indexPath as NSIndexPath).row]
            cell.delegate = self
            cell.configureCell(discountBO, forIndexPath: (indexPath as NSIndexPath).row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Selected Discount Delegates
    func getSelectedDiscount(_ selectedDiscount: DiscountInfoBO) {
        
        if selectedDiscount.isDiscountSelected == true {
            self.selectedDiscountArray?.append(selectedDiscount)
        }else {
            if (self.selectedDiscountArray?.contains(selectedDiscount) == true) {
                selectedDiscount.isSwitchOn = true
                self.selectedDiscountArray?.remove(at: (self.selectedDiscountArray?.index(of: selectedDiscount))!)
                
                for discountDetails in self.selectedDiscountArray! {
                    if discountDetails.discountID == selectedDiscount.discountID {
                        selectedDiscount.isSwitchOn = true
                        self.selectedDiscountArray?.remove(at: (self.selectedDiscountArray?.index(of: discountDetails))!)
                    }
                }
            }
            
        }
        self.reFreshView()
    }
    
    func addDiscount(_ selectedDiscount: DiscountInfoBO) {
        if selectedDiscount.isDiscountSelected == true {
            self.selectedDiscountArray?.append(selectedDiscount)
        }
        self.reFreshView()
    }
    
    // MARK : switchButtonStatusDelegate method
    func getSwitchButtonStatus(_ selectedDiscountBO: DiscountInfoBO) {
        
    }
    
    // MARK : Refresh View
    func reFreshView() {
        self.discountTableView.reloadData()
        self.selectedDiscountTableview.reloadData()
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
            
        case kGetAvailableDiscounts as String:
            self.discountsArray = response as? [DiscountInfoBO]
            self.reFreshView()
            
            break
            
        case kValidateCardTypeEncryptedNumber as String:
            
            let responseDict:NSDictionary = response as! NSDictionary
            let discountCode = discountNumberTextField.text
            let cardType = responseDict.getStringFromDictionary(withKeys: ["ValidateCardTypeEncryptedNumberResponse","ValidateCardTypeEncryptedNumberResult"]) as String
            self.searchDiscountByCardNumber(discountCode!, discountCardType: cardType)
            
            break
            
        case kValidateDiscountsRules as String:
            
            self.validatedDiscountsArray = response as? [DiscountInfoBO]
            naviController?.ticketBO?.discounts = NSMutableArray(array: self.validatedDiscountsArray!)
            Utility.sharedInstance.hideHUD()
            
            //display next discount screen with updated amount
            let checkOutStroyboardId = Utility.createStoryBoardid(kCheckOut)
            let nextDiscountViewController = checkOutStroyboardId.instantiateViewController(withIdentifier: "NextDiscountViewController") as! NextDiscountViewController
            nextDiscountViewController.ticketBO = naviController?.ticketBO
            naviController?.pushViewController(nextDiscountViewController, animated: true)
            
            break
            
        case kGetDiscountsByBarcodeOrName as String:
            let discountArrayByBarcode = response as? [DiscountInfoBO]
            for discount in discountArrayByBarcode! {
                self.selectedDiscountArray?.append(discount)
            }
            self.reFreshView()
            Utility.sharedInstance.hideHUD()
            
            break
            
        case kGetDiscountsFromClubCode as String:
            
            let discountsByAAACard = response as? [DiscountInfoBO]
            
            if self.selectedDiscountArray?.count > 0 {
                
                for aaaDiscount in discountsByAAACard! {
                    
                    var isAlreadyExist = false
                    
                    for discount in self.selectedDiscountArray! {
                        if discount.discountCode == aaaDiscount.discountCode {
                            isAlreadyExist = true
                            break
                        }
                    }
                    if !isAlreadyExist {
                        self.selectedDiscountArray?.append(aaaDiscount)
                    }
                }
                
            }else {
                for aaaDiscount in discountsByAAACard! {
                    self.selectedDiscountArray?.append(aaaDiscount)
                }
            }
            
            self.reFreshView()
            self.updateIdentifierKeyWithCAPOrAAA()
            
            break
            
        case kGetDiscountsAssoicatedWithLoyalty as String:
            let discountsByCAPCard = response as? [DiscountInfoBO]
            
            if self.selectedDiscountArray?.count > 0 {
                
                for capDiscount in discountsByCAPCard! {
                    
                    var isAlreadyExist = false
                    
                    for discount in self.selectedDiscountArray! {
                        if discount.discountCode == capDiscount.discountCode {
                            isAlreadyExist = true
                            break
                        }
                    }
                    if !isAlreadyExist {
                        self.selectedDiscountArray?.append(capDiscount)
                    }
                }
                
            }else {
                for capDiscount in discountsByCAPCard! {
                    self.selectedDiscountArray?.append(capDiscount)
                }
            }
            
            self.reFreshView()
            self.updateIdentifierKeyWithCAPOrAAA()
            Utility.sharedInstance.hideHUD()
            
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
