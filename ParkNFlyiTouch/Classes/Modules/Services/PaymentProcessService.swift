//
//  PaymentProcessService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 1/18/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
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


class PaymentProcessService: GenericServiceManager {
    
    var authenticateUser = String()
    var userName = String()
    var paramDict = NSDictionary()
    
    /**
     This method will create PaymentProcess request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func paymentProcessWebService(_ identifier: String, parameters: NSDictionary) {
        
//        self.identifier = identifier
//        let connection = ConnectionManager()
//        connection.delegate = self
//        self.paramDict = parameters
//        
//        let ticketDetails:TicketBO = parameters["TicketDetails"] as! TicketBO
//        let calculateRateDetails = parameters["CalculateDetails"] as! NSDictionary
//        let creditCardInfoBO:CreditCardInfoBO? = parameters["CreditCardInfoBO"] as? CreditCardInfoBO
//        self.authenticateUser = (naviController?.authenticateUser)!
//        self.userName = (naviController?.userName)!
//        
//        let soapMessage = self.createPaymentRequestXML(ticketDetails,amountDetails: calculateRateDetails,creditcardInfoBO:creditCardInfoBO)
//        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"PaymentProcess")
    }
    
//    func createPaymentRequestXML(_ ticketDetails:TicketBO, amountDetails:NSDictionary,creditcardInfoBO: CreditCardInfoBO?) -> String {
//        
//        let fpCardNoTag = ticketDetails.identifierKey
//        let fpCardNo = fpCardNoTag != nil && fpCardNoTag?.characters.count > 0 ? ("<par:FPCardNumber>" + fpCardNoTag! + "</par:FPCardNumber>\n") : "<par:FPCardNumber i:nil=\"true\" />\n"
//        
//        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
//        let deviceAddress = naviController?.deviceIdByDeviceByDeviceAddress?.deviceAddress
//        let deviceName = naviController?.deviceIdByDeviceByDeviceAddress?.deviceName
//        let updatedDateTime = (naviController?.updatedDate)! + "T" + (naviController?.updatedTime)!//"2015-11-30T13:17:23"
//        let ticketBarcode = ticketDetails.barcodeNumberString
//        let shiftCode = naviController?.shiftCode
//        let lastCharForCashier = authenticateUser.characters.last!
//        let  allCharExceptLastForCashier = authenticateUser.substring(to: authenticateUser.characters.index(before: authenticateUser.endIndex))
//        let cashierName = "\(allCharExceptLastForCashier)" + " " + "\(lastCharForCashier)"
//        var creditCardXML = ""
//        if let _ = creditcardInfoBO {
//            
//            creditCardXML = "<par:CreditPaymentList />\n"
//                + self.createFPCreditCardRequest(ticketDetails,amountDetails: amountDetails,creditcardInfoBO: creditcardInfoBO)
//        } else {
//            creditCardXML = self.creditPaymentRequest(ticketDetails,amountDetails: amountDetails) + "<par:FPCreditCard />\n"
//        }
//        
//        let paymentXML: String = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\">\n"
//            + "<soapenv:Header/>\n"
//            + "<soapenv:Body>\n"
//            + "<tem:PaymentProcess>\n"
//            + "<tem:iPayment>\n"
//            + creditCardXML
//            + "<par:SaleInformation>\n"
//            + "<par:CashierName>" + cashierName + "</par:CashierName>\n"
//            + "<par:CashierUserName>" + self.authenticateUser + "\\" + self.userName + "</par:CashierUserName>\n"
//            + "<par:DeviceAddress>" + deviceAddress! + "</par:DeviceAddress>\n"
//            + "<par:DeviceCode>" + deviceCode! + "</par:DeviceCode>\n"
//            + "<par:DeviceName>" + deviceName! + "</par:DeviceName>\n"
//            + "<par:ExitDateTime>" + updatedDateTime + "</par:ExitDateTime>\n"
//            + fpCardNo
//            + "<par:ShiftCode>" + shiftCode! + "</par:ShiftCode>\n"
//            + "<par:TicketBarcode>" + ticketBarcode! + "</par:TicketBarcode>\n"
//            + "<par:ccLinkedWithLoyalty />\n"
//            + "<par:paymentCreditInformation />\n"
//            + "</par:SaleInformation>\n"
//            + "</tem:iPayment>\n"
//            + "</tem:PaymentProcess>\n"
//            + "</soapenv:Body>\n"
//            + "</soapenv:Envelope>"
//        
//        return paymentXML
//    }
//    
//    func creditPaymentRequest(_ ticketDetails:TicketBO, amountDetails:NSDictionary) -> String {
//        
//        let deviceID = naviController?.deviceIdByDeviceByDeviceAddress?.deviceId
//        let parkingChargeTag = amountDetails.getInnerText(forKey: "a:ParkingCharge") as String
//        let parkingCharge = parkingChargeTag.characters.count > 0 ? ("<par:ParkingCharge>" + parkingChargeTag + "</par:ParkingCharge>\n") : "<par:ParkingCharge i:nil=\"true\" />\n"
//        
//        let totalAmount = amountDetails.getInnerText(forKey: "a:TotalCharge") as String
//        let guid = UUID().uuidString
//        let serviceCharge = amountDetails.getInnerText(forKey: "a:ServicesCharge") as String
//        let tickeId = ticketDetails.ticketID
//        let creditCardNumber = Encryptor.encrypt(paramDict["CreditCardNumber"] as! String)
//        let ccMonth = paramDict["CCMonth"] as! String
//        let ccYear = paramDict["CCYear"] as! String
//        
//        
//        let creditPaymentXML: String = ""
//            + "<par:CreditPaymentList>\n"
//            + "<par:PaymentCreditInformation>\n"
//            + "<par:AmountCharged>" + "10" + "</par:AmountCharged>\n"
//            + "<par:AuthCode />\n"
//            + "<par:CCMonth>" + ccMonth + "</par:CCMonth>\n"
//            + "<par:CCProcessorPassword i:nil=\"true\" />\n"
//            + "<par:CCProcessorUserName i:nil=\"true\" />\n"
//            + "<par:CCYear>" + ccYear + "</par:CCYear>\n"
//            + "<par:CardCVVNumber i:nil=\"true\" />\n"
//            + "<par:CardFirstSix i:nil=\"true\" />\n"
//            + "<par:CardLastFour i:nil=\"true\" />\n"
//            + "<par:CardTrackData i:nil=\"true\" />\n"
//            + "<par:CardType i:nil=\"true\" />\n"
//            + "<par:ChargeResult i:nil=\"true\" />\n"
//            + "<par:ExpiryDate i:nil=\"true\" />\n"
//            + "<par:IsSelected>true</par:IsSelected>\n"
//            + "<par:ManualEntry>true</par:ManualEntry>\n"
//            + "<par:MerchantRef>" + guid + "</par:MerchantRef>\n"
//            + parkingCharge
//            + "<par:PaymentResult>Other</par:PaymentResult>\n"
//            + "<par:PaymentResultText i:nil=\"true\" />\n"
//            + "<par:ServiceCharge>" + serviceCharge + "</par:ServiceCharge>\n"
//            + "<par:TotalCharge>" + totalAmount + "</par:TotalCharge>\n"
//            + "<par:TrackData>" + creditCardNumber + "</par:TrackData>\n"
//            + "<par:TransactionID i:nil=\"true\" />\n"
//            + "<par:UnMaskedCardNumber i:nil=\"true\" />\n"
//            + "<par:UserData1>" + tickeId! + "</par:UserData1>\n"
//            + "<par:UserData2></par:UserData2>\n"
//            + "<par:UserData3>" + self.authenticateUser + "\\" + self.userName + "</par:UserData3>\n"
//            + "<par:UserData4>" + deviceID! + "</par:UserData4>\n"
//            + "<par:UserData5></par:UserData5>\n"
//            + "</par:PaymentCreditInformation>\n"
//            + "</par:CreditPaymentList>\n"
//        
//        return creditPaymentXML
//    }
//    
//    func createFPCreditCardRequest(_ ticketDetails:TicketBO, amountDetails:NSDictionary, creditcardInfoBO: CreditCardInfoBO?) -> String {
//        
//        let parkingChargeTag = amountDetails.getInnerText(forKey: "a:ParkingCharge") as String
//        let parkingCharge = parkingChargeTag.characters.count > 0 ? ("<par:ParkingCharge>" + parkingChargeTag + "</par:ParkingCharge>\n") : "<par:ParkingCharge i:nil=\"true\" />\n"
//        
//        let firstFive = creditcardInfoBO?.cardNumberFirstFive
//        let lastFour = creditcardInfoBO?.cardNumberLastFour
//        let fpCardNumber = creditcardInfoBO?.fpCardNumber
//        let nameOnCard = creditcardInfoBO?.nameOnCard
//        let totalAmount = amountDetails.getInnerText(forKey: "a:TotalCharge") as String
//        let guid = UUID().uuidString
//        let serviceCharge = amountDetails.getInnerText(forKey: "a:ServicesCharge") as String
//        let postalCode = (creditcardInfoBO?.postalCode)!
//        let personID = (creditcardInfoBO?.personID)!
//        let islinked = creditcardInfoBO?.isLinked
//        let isprimary = creditcardInfoBO?.isPrimary
//        let isSelected = creditcardInfoBO?.isSelected
//        let expiryMonth = creditcardInfoBO?.expiryMonth
//        let expiryYear = creditcardInfoBO?.expiryYear
//        let cardNumber = creditcardInfoBO?.unMaskedNumber
//        let cardType = creditcardInfoBO?.cardType
//        let tickeId = ticketDetails.ticketID
//        let creditCardID = (creditcardInfoBO?.creditCardID)!
//        let creditcardTypeID = (creditcardInfoBO?.creditCardTypeID)!
//        let deviceID = naviController?.deviceIdByDeviceByDeviceAddress?.deviceId
//        
//        
//        var fPCreditCardXML: String = ""
//        
//        fPCreditCardXML = "<par:FPCreditCard>\n"
//            + "<par:AddressID i:nil=\"true\" />\n"
//            + "<par:AmountCharged>" + "10" + "</par:AmountCharged>\n"
//            + "<par:AuthCode />\n"
//            + "<par:CardCode i:nil=\"true\" />\n"
//            + "<par:CardExpiryMonth>" + expiryMonth! + "</par:CardExpiryMonth>\n"
//            + "<par:CardExpiryYear>" + expiryYear! + "</par:CardExpiryYear>\n"
//            + "<par:CardNumber>" + cardNumber! + "</par:CardNumber>\n"
//            + "<par:CardNumberFirstFive>" + firstFive! + "</par:CardNumberFirstFive>\n"
//            + "<par:CardNumberLastFour>" + lastFour! + "</par:CardNumberLastFour>\n"
//            + "<par:CardType>" + cardType! + "</par:CardType>\n"
//            + "<par:CreditCardID>" + "\(creditCardID)" + "</par:CreditCardID>\n"
//            + "<par:CreditCardTypeID>" + "\(creditcardTypeID)" + "</par:CreditCardTypeID>\n"
//            + "<par:FPCardNumber>" + fpCardNumber! + "</par:FPCardNumber>\n"
//            + "<par:IsLinked>" + "\(islinked!)" + "</par:IsLinked>\n"
//            + "<par:IsPrimary>" + "\(isprimary!)" + "</par:IsPrimary>\n"
//            + "<par:IsSelected>" + "\(isSelected!)" + "</par:IsSelected>\n"
//            + "<par:MerchantRef>" + guid + "</par:MerchantRef>\n"
//            + "<par:NameOnCard>" + nameOnCard! + "</par:NameOnCard>\n"
//            + parkingCharge
//            + "<par:PaymentResult>Other</par:PaymentResult>\n"
//            + "<par:PaymentResultText i:nil=\"true\" />\n"
//            + "<par:PersonID>" + "\(personID)" + "</par:PersonID>\n"
//            + "<par:PostalCode>" + "\(postalCode)" + "</par:PostalCode>\n"
//            + "<par:ServiceCharge>" + serviceCharge + "</par:ServiceCharge>\n"
//            + "<par:TotalCharge>" + totalAmount + "</par:TotalCharge>\n"
//            + "<par:TransactionID i:nil=\"true\" />\n"
//            + "<par:UnMaskedCardNumber>" + cardNumber! + "</par:UnMaskedCardNumber>\n"
//            + "<par:UserData1>" + tickeId! + "</par:UserData1>\n"
//            + "<par:UserData2></par:UserData2>\n"
//            + "<par:UserData3>" + self.authenticateUser + "\\" + self.userName + "</par:UserData3>\n"
//            + "<par:UserData4>" + deviceID! + "</par:UserData4>\n"
//            + "<par:UserData5></par:UserData5>\n"
//            + "</par:FPCreditCard>\n"
//        
//        return fPCreditCardXML
//    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
//        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if dict.getObjectFromDictionary(withKeys: ["PaymentProcessResponse","PaymentProcessResult","a:Result"]) != nil {
            
            let paymentStatusDict: NSDictionary = dict.getObjectFromDictionary(withKeys: ["PaymentProcessResponse","PaymentProcessResult","a:Status"]) as! NSDictionary
            
            if paymentStatusDict.getInnerText(forKey: "a:ErrCode") == "0" {
                if self.delegate?.connectionDidFinishLoading != nil {
                    self.delegate!.connectionDidFinishLoading!(self.identifier, response: dict)
                }
            }else {
                if self.delegate?.didFailedWithError != nil {
                    self.delegate!.didFailedWithError!(self.identifier, errorMessage: paymentStatusDict.getInnerText(forKey: "a:Message") as String)
                }
            }
            
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate!.didFailedWithError!(self.identifier, errorMessage: klServerDownMsg)
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
