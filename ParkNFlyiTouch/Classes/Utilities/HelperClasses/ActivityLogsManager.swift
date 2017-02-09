//
//  ActivityLogsManager.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 18/03/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ActivityLogsManager: NSObject, GenericServiceManagerDelegate {
    
    var operationQueue: OperationQueue?
    var taskIdentifier: UIBackgroundTaskIdentifier = 0
    var logDataArray: [[String:String]] = [[String:String]]()
    
    class var sharedInstance: ActivityLogsManager {
        struct Static {
            static let instance: ActivityLogsManager = ActivityLogsManager()
        }
        return Static.instance
    }
    
    func logActivity(_ message: String, logType: String) {
        
        _ = self.getOperationQueue()
        let logData: [String:String] = ["message":message, "logType":logType]
        
        let app: UIApplication = UIApplication.shared
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        bgTask = app.beginBackgroundTask(expirationHandler: {() -> Void in
            app.endBackgroundTask(bgTask)
        })
        
        let operation = Synchronisation.operationParametersWithDelegate(self)
        operation.logData = logData
        self.operationQueue!.addOperation(operation)
        
        app.endBackgroundTask(bgTask)
    }
    
    func addLogActivity(_ message: String, logType: String) {
        
        var logData = [String:String]()
        
        if let _ = naviController?.ticketBO?.barcodeNumberString {
            logData = ["message":message, "logType":logType, "barcode":(naviController?.ticketBO?.barcodeNumberString)!]
        } else {
            logData = ["message":message, "logType":logType]
        }
        
        self.logDataArray.append(logData)
    }
    
    func logUserActivity(_ message: String, logType: String) {
        
        if message != "" || logType != "" {
            self.addLogActivity(message, logType: logType)
        }
        
        var index = 0
        for logData in self.logDataArray {
            index += 1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(index) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                let insertCustomLogFromClientService:InsertCustomLogFromClientService = InsertCustomLogFromClientService()
                insertCustomLogFromClientService.delegate = nil
                insertCustomLogFromClientService.insertCustomLogFromClientService(kInsertCustomLogFromClient, parameters: logData as NSDictionary)
            }
        }
        self.logDataArray.removeAll()
    }
    
    // MARK: - NSOperationQueue Methods
    func getOperationQueue() -> OperationQueue {
        if self.operationQueue != nil {
            return self.operationQueue!
        }
        self.operationQueue = OperationQueue()
        operationQueue!.maxConcurrentOperationCount = 1
        operationQueue!.addObserver(self, forKeyPath: "operations", options: .new, context: nil)
        return operationQueue!
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (object! as AnyObject).isEqual(self.operationQueue) && keyPath == "operations" {
            
            let operations: NSArray = change![NSKeyValueChangeKey.newKey] as! NSArray
            
            if self.hasActiveOperations(operations) {
                
                if (self.taskIdentifier == UIBackgroundTaskInvalid) {
                    print("begin task...")
                    self.taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
            } else {
                
                if (self.taskIdentifier != UIBackgroundTaskInvalid) {
                    UIApplication.shared.endBackgroundTask(self.taskIdentifier)
                    self.taskIdentifier = UIBackgroundTaskInvalid
                    print("end task...")
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func hasActiveOperations(_ operations: NSArray) -> Bool {
        
        for operation in operations {
            if ((operation as AnyObject).isCancelled == nil) {
                return true
            }
        }
        return false
    }
}
