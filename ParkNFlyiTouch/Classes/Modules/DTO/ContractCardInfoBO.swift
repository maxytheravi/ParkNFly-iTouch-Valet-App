//
//  ContractCardInfoBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas on 12/1/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ContractCardInfoBO: NSObject {
    
    var cardOwnerName: String? = nil
    var cardPhoneNumber: String? = nil
    var cardNumber: String? = nil
    var contractCardNumbersID: String? = nil
    
    func getContractCardInfoBOFromDictionary(_ attributeDict: NSDictionary) -> ContractCardInfoBO {
        
        self.cardOwnerName = attributeDict.getInnerText(forKey: "a:_CardOwnerName")
        self.cardPhoneNumber = attributeDict.getInnerText(forKey: "a:_CardPhoneNumber")
        self.cardNumber = attributeDict.getInnerText(forKey: "a:_CardNumber")
        self.contractCardNumbersID = attributeDict.getInnerText(forKey: "a:_ContractCardNumbersID")
        
        return self
    }
}
