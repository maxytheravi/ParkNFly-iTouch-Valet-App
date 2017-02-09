//
//  Synchronisation.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 18/03/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

let kDEFAULT_TIMEOUT = 30.0

class Synchronisation: Operation {
    
    var activityLogsManager: ActivityLogsManager?
    var logData: [String:String] = [String:String]()
    
    class func operationParametersWithDelegate(_ delegate: AnyObject) -> Synchronisation {
        let operation: Synchronisation = Synchronisation()
        operation.activityLogsManager = delegate as? ActivityLogsManager
        return operation
    }
    
    override func main() {
        
    }
    
    func callWebserviceWithURLStr(_ urlStr: String, withParams params: String) {
        
    }
}
