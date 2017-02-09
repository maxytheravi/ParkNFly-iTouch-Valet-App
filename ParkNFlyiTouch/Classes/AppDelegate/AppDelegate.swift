//
//  AppDelegate.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 22/09/15.
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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Utility.sharedInstance.initialiseUtility()
        self.window?.rootViewController = Utility.sharedInstance.loginViewController
        
        if let serverName = Keychain.getStringForKey("ServerName") , !Keychain.getStringForKey("ServerName").isEmpty {
            UserDefaults.standard.set(serverName, forKey: "ServerName")
            UserDefaults.standard.synchronize()
            Keychain.deleteString(forKey: "ServerName")
        }
        
        if let deviceName = Keychain.getStringForKey("DeviceName") , !Keychain.getStringForKey("DeviceName").isEmpty {
            UserDefaults.standard.set(deviceName, forKey: "DeviceName")
            UserDefaults.standard.synchronize()
            Keychain.deleteString(forKey: "DeviceName")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let baseURL = UserDefaults.standard.object(forKey: "CheckBaseURLChanged")
        
        if let _ = baseURL {
            
            let baseURLStr: String = baseURL as! String
            
            if baseURLStr != Utility.getBaseURL() {
                
                UserDefaults.standard.set(Utility.getBaseURL(), forKey: "CheckBaseURLChanged")
                UserDefaults.standard.synchronize()
                
                naviController!.clearDataOnServerChanged()
                Utility.sharedInstance.loginViewController?.logout()
//                Utility.sharedInstance.loginViewController?.callWebServices()
            }
        } else {
            UserDefaults.standard.set(Utility.getBaseURL(), forKey: "CheckBaseURLChanged")
            UserDefaults.standard.synchronize()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

@objc(MyApplication) class MyApplication: UIApplication, GenericServiceManagerDelegate {
    
    var idleTimer: Timer?
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        let allTouches = event.allTouches
        if allTouches != nil && allTouches!.count > 0 {
            let phase: UITouchPhase = ((allTouches!.first! )).phase
            if phase == .began || phase == .ended {
                self.resetIdleTimer()
            }
        }
    }
    
    func resetIdleTimer() {
        if (idleTimer != nil) {
            idleTimer!.invalidate()
            idleTimer = nil
        }
        
        if naviController?.autoCloseShiftRequired == true {
            idleTimer = Timer.scheduledTimer(timeInterval: Double((naviController?.autoCloseShiftTimeOutInMinutes)!) * 60.0, target: self, selector: #selector(MyApplication.idleTimerExceeded), userInfo: nil, repeats: false)
        }
    }
    
    func idleTimerExceeded() {
        if naviController?.shiftCode != nil && naviController?.shiftCode?.characters.count > 0 {
            let shiftCloseManager:ShiftCloseService = ShiftCloseService()
            shiftCloseManager.delegate = self
            shiftCloseManager.shiftCloseWebService(kShiftClose, parameters: NSDictionary())
        }
        Utility.sharedInstance.loginViewController?.logout()
    }
}
