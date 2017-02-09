//
//  NotesHistoryBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/18/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class NotesHistoryBO: NSObject {
    
    var cashierUserName: String? = nil
    var noteLogDate: String? = nil
    var sortDate: Date? = nil
    var section: String? = nil
    var noteDescription: String? = nil
    
    func getNotesHistoryBOFromDictionary(_ attributeDict: NSDictionary) -> NotesHistoryBO {
        
        self.noteDescription = attributeDict.getInnerText(forKey: "a:All_Notes")
        self.cashierUserName = attributeDict.getInnerText(forKey: "a:CashierUserName")
        self.noteLogDate = attributeDict.getInnerText(forKey: "a:LogDates")
        self.section = attributeDict.getInnerText(forKey: "a:Section")
        
        return self
    }
}
