//
//  Utility.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 9/30/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    var loginViewController: LoginViewController?
    var appDelegate: AppDelegate?
    var progressHUD: MBProgressHUD?
    var hudCount: Int = 0
    
    class var sharedInstance: Utility {
        struct Static {
            static let instance: Utility = Utility()
        }
        return Static.instance
    }
    
    func initialiseUtility() {
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        naviController = Utility.getNewNavigationControllerInstance()
        
        let loginStoryboard = Utility.createStoryBoardid(kLogin)
        self.loginViewController = loginStoryboard.instantiateInitialViewController() as? LoginViewController
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status: AFNetworkReachabilityStatus) -> Void in
            
            switch status.hashValue{
            case AFNetworkReachabilityStatus.notReachable.hashValue:
                print("Not reachable")
            case AFNetworkReachabilityStatus.reachableViaWiFi.hashValue , AFNetworkReachabilityStatus.reachableViaWWAN.hashValue :
                print("Reachable")
            default:
                print("Unknown status")
            }
        }
    }
    
    class func getNewNavigationControllerInstance() -> BaseNavigationController {
        let mainStoryboard = Utility.createStoryBoardid(kMain)
        let naviController: BaseNavigationController = (mainStoryboard.instantiateInitialViewController() as? BaseNavigationController)!
        return naviController
    }
    
    func createHud(_ label: NSString) {
        progressHUD = MBProgressHUD(view: self.appDelegate?.window)
        self.appDelegate?.window!.addSubview(progressHUD!)
        progressHUD?.labelText = label as String
        progressHUD?.removeFromSuperViewOnHide = true
        progressHUD?.show(true)
    }
    
    func destroyHud() {
        self.progressHUD?.isHidden = true
        self.progressHUD?.removeFromSuperview()
        self.progressHUD = nil
    }
    
    func showHUDWithLabel(_ label: NSString) {
        
        if self.hudCount == 0 {
            
            self.destroyHud()
            self.createHud(label)
        }
        
        self.hudCount += 1
    }
    
    func hideHUD() {
        
        self.hudCount -= 1
        if self.hudCount < 0 {
            self.hudCount = 0
        }
        
        if self.hudCount == 0 {
            
            //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.destroyHud()
            //            })
        }
    }
    
    /*class func getBaseURL() -> String {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var url: String
        var serverName: String = ""
        
        if (defaults.stringForKey("ServerName") != nil) {
            serverName = defaults.stringForKey("ServerName")!
        }
        
        if serverName == "" {
            
            let settingsPropertyListPath = NSBundle.mainBundle().pathForResource("Settings.bundle/Root", ofType: "plist")
            let settingsPropertyListDict: NSDictionary = NSDictionary(contentsOfFile: settingsPropertyListPath!)!
            let preferenceArray: NSMutableArray = settingsPropertyListDict.objectForKey("PreferenceSpecifiers") as! NSMutableArray
            
            let registerableDictionary: NSMutableDictionary = NSMutableDictionary()
            
            for var i: Int = 0 ; i < preferenceArray.count ; i++ {
                let key1: NSString? = ((preferenceArray.objectAtIndex(i) as! NSDictionary).objectForKey("Key")) as? NSString
                if let key = key1 {
                    let value: AnyObject = preferenceArray.objectAtIndex(i).objectForKey("DefaultValue")!
                    registerableDictionary.setObject(value, forKey: key)
                    serverName = value as! String
                }
            }
            
            NSUserDefaults.standardUserDefaults().registerDefaults((registerableDictionary as NSDictionary) as! [String : AnyObject])
            NSUserDefaults.standardUserDefaults().synchronize()
            url = "http://" + "\(serverName)" + ":8531/ParkNFlyService/SOAP"
            
        } else {
            url = "http://" + "\(serverName)" + ":8531/ParkNFlyService/SOAP"
        }
        
        return url
    }*/
    
    class func getBaseURL() -> String {
        
//        if let serverName = Keychain.getStringForKey("ServerName") {
        if let serverName = UserDefaults.standard.object(forKey: "ServerName") , !(UserDefaults.standard.object(forKey: "ServerName") as! String).isEmpty {
            return "http://" + "\(serverName)" + ":8531/ParkNFlyService/SOAP"
        } else {
            return ""
        }
    }
    
    class func isLax() -> Bool {
        if let serverName = UserDefaults.standard.object(forKey: "ServerName"), !(UserDefaults.standard.object(forKey: "ServerName") as! String).isEmpty {
            let serverNameString = "\(serverName)"
            if serverNameString == kLax {
                return true
            }
        }
        return false // It should be false
    }
    
    class func getDeviceIdentifier() -> NSString {
        
        if kDeviceIdentifer == "" {
//            if let deviceName = Keychain.getStringForKey("DeviceName") {
            if let deviceName = UserDefaults.standard.object(forKey: "DeviceName") , !(UserDefaults.standard.object(forKey: "DeviceName") as! String).isEmpty {
                return deviceName as! NSString//UIDevice.currentDevice().name
            } else {
                return ""
            }
        } else {
            return kDeviceIdentifer as NSString
        }
    }
    
    class func createStoryBoardid (_ storyboardId:String) -> UIStoryboard {
        
        return UIStoryboard(name: storyboardId, bundle: nil)
        
    }
    
    class func iphoneScreenSize() -> Bool {
        
        let iphone4Inch = UIScreen.main.bounds
        
        if iphone4Inch.height == 480 {
            return true
        }
        return false
    }
    
    class func getPriceString(_ price: Double) -> String {
        return String.localizedStringWithFormat("$ %.2f", price)
    }
    
    // MARK: - Validate Numbers
    class func checkForFPCardNumberIsValid(_ input: String) -> Bool {
        for chr in input.characters {
            if !(chr >= "0" && chr <= "9") {
                return false
            }
        }
        if !(input.hasPrefix("30852") || input.hasPrefix("20112")) {
            return false
        }
        return true
    }
    
    class func checkForPreprintedNumberIsValid(_ input: String) -> Bool {
        if input.range(of: "-") != nil{
            return true
        }
        return false
    }
    
    class func checkForReservationCodeIsValid(_ input: String) -> Bool {
        for chr in input.characters {
            if !(chr >= "0" && chr <= "9") && !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") {
                return false
            }
        }
        return true
    }
    
    class func checkForBarcodeIsValid(_ input: String) -> Bool {
        for chr in input.characters {
            if !(chr >= "0" && chr <= "9") && !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") {
                return false
            }
        }
        return true
    }
    
    // MARK: Date and Time Methods
    class func stringFromDate(_ formatter:String, date:Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        return dateFormatter.string(from: date)
    }
    
    class func getUTCFromCurrentTimeZone(_ dateStr: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date: Date = dateFormatter.date(from: dateStr)!
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: date)
    }
    
    class func getCurrentTimeZoneFromUTC(_ dateStr: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date: Date = dateFormatter.date(from: dateStr)!
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
    
    class func stringFromDateAdjustmentWithT(_ formatter:String, date:Date) -> String {
        
        let token = (formatter.components(separatedBy: "T") as NSArray)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = token.firstObject as! String
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let dateStr: String = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = token.lastObject as! String
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStr: String = dateFormatter.string(from: date)
        
        return dateStr + "T" + timeStr
    }
    
    class func stringFromDateStringWithoutT(_ dateStr: String) -> String {
        let token: NSArray = (dateStr.components(separatedBy: "T") as NSArray)
        let dateStr: String = token[0] as! String
        let timeStr: String = (token[1] as! NSString).substring(to: 8)
        return "\(dateStr) \(timeStr)"
    }
    
    class func dateFromString(_ dateStr: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat as String
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        if let date = dateFormatter.date(from: dateStr) {
            return date
        }
        return nil
    }
    
    class func dateStringFromString(_ dateStr: String, dateFormat: String, conversionDateFormat:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat as String
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            return Utility.stringFromDate(conversionDateFormat, date: date)
        }
        return nil
    }
    
    class func getServerDateTimeFormat() -> String {
        return "yyyy-MM-ddTHH:mm:ss"
    }
    
    class func getDisplyDateTimeFormat() -> String {
        return "EEE MM/dd/yy hh:mm a"
    }
    
    class func getDisplyDateFormat() -> String {
        return "EEE MM/dd/yy"
    }
    
    class func getDisplyShortDateFormat() -> String {
        return "MM/dd/yy"
    }
    
    class func getDisplyTimeFormat() -> String {
        return "hh:mm a"
    }
    
    //
    //    class func getServerDateTimeFormat() -> String {
    //        return "yyyy-MM-dd HH:mm:ss"
    //    }
    //
    //    class func getSendingToServerDateTimeFormat() -> String {
    //        return "yyyy-MM-ddTHH:mm:ss"
    //    }
    //
    //    class func convertStringDateToDate(dateStr: String, dateFormat: String) -> NSDate {
    //       let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = dateFormat as String
    //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
    //        let date = dateFormatter.dateFromString(dateStr)
    //        return date!
    //    }
    //
    //    class func convertDateToStringDate(date: NSDate, dateFormat: String) -> String {
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = dateFormat as String///this is you want to convert format
    //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
    //        let timeStamp = dateFormatter.stringFromDate(date)
    //        return timeStamp
    //    }
    //
    //    class func getFormattedDateStringFromStringDate(dateStr: String, fromDateFormat: String, toDateFormat: String) -> String {
    //
    //        return Utility.convertDateToStringDate(Utility.convertStringDateToDate(dateStr, dateFormat: fromDateFormat), dateFormat: toDateFormat) as String
    //    }
    //
    //
    //    class func getFormatedDateTimeFromServerWithT(serverTime: String) -> String {
    //        let token: NSArray = serverTime.componentsSeparatedByString("T")
    //        let dateStr: String = token[0] as! String
    //        let timeStr: String = (token[1] as! NSString).substringToIndex(8)
    //        return "\(dateStr)T\(timeStr)"
    //    }
    
    //Optimised
    class func getFormatedDateTimeWithT(_ dateTime: String) -> String {
        
        if dateTime.characters.count < 19 {return dateTime}
        
        let token: NSArray = (dateTime.components(separatedBy: "T") as NSArray)
        let dateStr: String = token[0] as! String
        let timeStr: String = (token[1] as! NSString).substring(to: 8)
        return "\(dateStr)T\(timeStr)"
    }
    
    class func getFormatedDateBeforeT(_ dateTime: String) -> String {
        
        if dateTime.characters.count < 10 {return dateTime}
        
        let token: NSArray = (dateTime.components(separatedBy: "T") as NSArray)
        let dateStr: String = token[0] as! String
        return dateStr
    }
    
    class func getFormatedTimeAfterT(_ dateTime: String) -> String {
        
        if dateTime.characters.count < 19 {return dateTime}
        
        let token: NSArray = (dateTime.components(separatedBy: "T") as NSArray)
        let timeStr: String = (token[1] as! NSString).substring(to: 8)
        return timeStr
    }
    
    class func getTimeWithHHMMFromHHMMSS(_ timeStr: String) -> String {
        if timeStr.characters.count < 8 {return timeStr}
        return (timeStr as NSString).substring(to: 5)
    }
    
    class func getTimeWithHHMMSSFromHHMM(_ timeStr: String) -> String {
        if timeStr.characters.count < 5 {return timeStr}
        return timeStr + ":00"
    }
}
