//
//  ActionsheetObject.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/15/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol ActionsheetManagerDelegate {
    
    func getActionsheet(_ optionMenu:UIAlertController)
    @objc optional func getSelectedOptionFromActionsheet(_ selectedOption:String, parkingTypeID:String)
    @objc optional func getCreditCardFromActionsheet(_ selectedOption:String)
    @objc optional func getLoactionNameFromActionSheet(_ selectedOption:String)
}

class ActionsheetObject: NSObject {
    
    var delegate:ActionsheetManagerDelegate?
    
    func createActionsheet(_ numberOfItem:[AnyObject], identifier:String) {
        
        switch (identifier) {
            
        case kParkingTypeActionSheet:
            self.parkingTypeActionsheet(numberOfItem as! [ProductSetServiceBO])
            break
            
        case kCreditCardTypeActionSheet:
            self.creditCardTypeActionSheet(numberOfItem as NSArray)
            
            break
            
        case kLocationNamesActionSheet:
            self.locationNamesActionSheet(numberOfItem as! [LocationBO])
            
            break
            
        default:
            break
        }
    }
    
    func locationNamesActionSheet(_ locationNames: [LocationBO]) {
        
        var locationNamesMenu = UIAlertController()
        locationNamesMenu = UIAlertController(title: "Locations", message: nil, preferredStyle: .actionSheet)
        
        for locationName in locationNames {
            let action = UIAlertAction(title: locationName.locationName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                if self.delegate?.getLoactionNameFromActionSheet != nil {
                    self.delegate?.getLoactionNameFromActionSheet!(locationName.locationName!)
                }
            })
            locationNamesMenu.addAction(action)
        }
        
        let action = UIAlertAction(title: klCancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.delegate?.getLoactionNameFromActionSheet != nil {
                self.delegate?.getLoactionNameFromActionSheet!("")
            }
        })
        locationNamesMenu.addAction(action)
        
        if self.delegate?.getLoactionNameFromActionSheet != nil {
            self.delegate?.getActionsheet(locationNamesMenu)
        }

    }
    
    func creditCardTypeActionSheet(_ cardTypes: NSArray) {
        
        var cardTypesMenu = UIAlertController()
        cardTypesMenu = UIAlertController(title: "Card Type", message: nil, preferredStyle: .actionSheet)
        
        for cardType in cardTypes {
            
            let action = UIAlertAction(title: cardType as? String, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                if self.delegate?.getCreditCardFromActionsheet != nil {
                    self.delegate?.getCreditCardFromActionsheet!(cardType as! String)
                }
            })
            cardTypesMenu.addAction(action)
        }
        
        let action = UIAlertAction(title: klCancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.delegate?.getCreditCardFromActionsheet != nil {
                self.delegate?.getCreditCardFromActionsheet!("")
            }
        })
        cardTypesMenu.addAction(action)
        
        if self.delegate?.getCreditCardFromActionsheet != nil {
            self.delegate?.getActionsheet(cardTypesMenu)
        }
        
    }
    
    func parkingTypeActionsheet(_ parkingType:[ProductSetServiceBO]) {
        
        var parkingTypeArray:[Dictionary<String,String>] = []
        
        for productSetService:ProductSetServiceBO in parkingType {
            let parkingTypeDictionary = ["parkingTypeName":productSetService.parkingTypeName!, "parkingTypeID":String(productSetService.parkingTypeID!)]
            parkingTypeArray.append(parkingTypeDictionary)
        }
        
        var parkingTypesMenu = UIAlertController()
        parkingTypesMenu = UIAlertController(title: "Parking Type", message: nil, preferredStyle: .actionSheet)
        
        for parkingType:Dictionary<String,String> in parkingTypeArray {
            
            let action = UIAlertAction(title: parkingType["parkingTypeName"], style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                if self.delegate?.getSelectedOptionFromActionsheet != nil {
                    self.delegate?.getSelectedOptionFromActionsheet!(parkingType["parkingTypeName"]!, parkingTypeID: parkingType["parkingTypeID"]!)
                }
            })
            parkingTypesMenu.addAction(action)
        }
        
        let action = UIAlertAction(title: klCancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.delegate?.getSelectedOptionFromActionsheet != nil {
                self.delegate?.getSelectedOptionFromActionsheet!("",parkingTypeID: "")
            }
        })
        parkingTypesMenu.addAction(action)
        
        if self.delegate?.getSelectedOptionFromActionsheet != nil {
            self.delegate?.getActionsheet(parkingTypesMenu)
        }
    }
    
}
