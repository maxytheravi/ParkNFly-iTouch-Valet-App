//
//  LoginViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 22/09/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate, XMLParserDelegate {
    
    /** UITextField outlet for username textField.
     */
    @IBOutlet weak var usernameTextField: TextField!
    
    /** UITextField outlet for password textField.
     */
    @IBOutlet weak var passwordTextField: TextField!
    
    /** NSLayoutConstraint outlet for center Y.
     */
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var applicationVersion: UILabel!
    
    fileprivate var orignalCenterYConstraint: CGFloat = 0.0
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        orignalCenterYConstraint = centerYConstraint.constant
        //        self.callGetiTouchConfigWebServices()
        
        let appInfo = Bundle.main.infoDictionary! as Dictionary<String,AnyObject>
        let shortVersionString = appInfo["CFBundleShortVersionString"] as! String
        let bundleVersion = appInfo["CFBundleVersion"] as! String
        
        self.applicationVersion.text = "Version: " + shortVersionString + " (" + bundleVersion + ")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.passwordTextField.text = ""
        
        //Add observer for Keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        #if arch(i386) || arch(x86_64)
            usernameTextField.text = "rkaradbhajane"
            passwordTextField.text = "raka_33"
        #endif
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            //            if Keychain.getStringForKey("ServerName") == nil || Keychain.getStringForKey("ServerName").characters.count == 0 {
            //                self.settingsButtonAction(UIButton())
            //            }
            
            if UserDefaults.standard.object(forKey: "ServerName") == nil || (UserDefaults.standard.object(forKey: "ServerName") as! String).isEmpty {
                self.settingsButtonAction(UIButton())
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Add observer for Keyboard notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func callGetiTouchConfigWebServices() {
        
        if let _ = UserDefaults.standard.object(forKey: "ServerName") , !(UserDefaults.standard.object(forKey: "ServerName") as! String).isEmpty {
            
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let getiTouchConfig: GetiTouchConfig = GetiTouchConfig()
            getiTouchConfig.delegate = self
            getiTouchConfig.getGetiTouchConfigService(kGetiTouchConfig, parameters:NSDictionary())
        }
    }
    
    // MARK: UIButton action
    /**
     This method will navigate view to NavigationController
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    @IBAction func loginButtonAction(_ sender: AnyObject?) {
        
        /* //WARNING: bypass login
         self.login()
         return
         // */
        
        self.view.endEditing(true)
        
        //        if Keychain.getStringForKey("ServerName") == nil || Keychain.getStringForKey("ServerName").characters.count == 0 {
        if UserDefaults.standard.object(forKey: "ServerName") == nil || (UserDefaults.standard.object(forKey: "ServerName") as! String).isEmpty {
            
            let alert = UIAlertController(title: klError, message: "Please add server to connect", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.validateLogin() {
            
            if AFNetworkReachabilityManager.shared().isReachable {
                print("Reachable")
            } else {
                print("Not reachable")
            }
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            
            let serviceManager: LoginService = LoginService()
            serviceManager.delegate = self
            serviceManager.loginWebService(kLoginWebservice, parameters:["Username":usernameTextField.text!, "Password":passwordTextField!.text!])
            ActivityLogsManager.sharedInstance.logUserActivity(("Login button is tapped"), logType: "Normal")
        }
        else {
            animateTextFieldsForWrongCredentials()
        }
    }
    
    @IBAction func settingsButtonAction(_ sender: UIButton) {
        
        let mainStroyboardId = Utility.createStoryBoardid(kLogin)
        let maintenanceViewController = mainStroyboardId.instantiateViewController(withIdentifier: "MaintenanceViewController") as! MaintenanceViewController
        self.present(maintenanceViewController, animated: true, completion: nil)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch identifier {
            
        case kLoginWebservice as String:
            
            let responseDict: NSDictionary = response as! NSDictionary
            naviController?.userName = usernameTextField.text
            naviController?.shiftCode = responseDict.getStringFromDictionary(withKeys: ["AuthenticateUserResponse","shiftCode"]) as NSString as String
            naviController?.authenticateUser = responseDict.getStringFromDictionary(withKeys: ["AuthenticateUserResponse","AuthenticateUserResult"]) as String
            
            self.callGetiTouchConfigWebServices()
            
            break
            
        case kGetiTouchConfig as String:
            
            if naviController?.deviceIdByDeviceByDeviceAddress != nil && naviController?.facilityConfig != nil && naviController?.allLocationArray != nil && naviController?.productArray != nil && naviController?.vehicleMakeArray != nil && naviController?.serviceDictionary != nil {
                self.present(naviController!, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: klError, message: klServerDownMsg, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        default:
            break
        }
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        
        switch identifier {
            
        case kLoginWebservice as String:
            
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kShiftClose as String:
            
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kGetiTouchConfig as String:
            
            let alert = UIAlertController(title: klError, message: klServerDownMsg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        default: break
        }
    }
    
    // MARK: Functional Methids
    func validateLogin() -> Bool {
        
        if (usernameTextField.text?.characters.count)! > 0 && (passwordTextField.text?.characters.count)! > 0 {
            return true
        }
        return false
    }
    
    //    func login() {
    //        self.callWebServices()
    //    }
    
    func autoLogin() {
        self.logout()
    }
    
    func logout() {
        naviController!.clearDataOnLoggedOut()
        _ = naviController?.popToRootViewController(animated: false)
        naviController!.dismiss(animated: true, completion: nil)
    }
    
    func animateTextFieldsForWrongCredentials() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        
        //adding animation for username textfield
        animation.fromValue = NSValue(cgPoint: CGPoint(x: usernameTextField.center.x - 10, y: usernameTextField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: usernameTextField.center.x + 10, y: usernameTextField.center.y))
        usernameTextField.layer.add(animation, forKey: "position")
        
        //adding animation for password textfield
        animation.fromValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x - 10, y: passwordTextField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x + 10, y: passwordTextField.center.y))
        passwordTextField.layer.add(animation, forKey: "position")
    }
    
    // MARK: - Keyboard notifications
    /**
     This method will scroll view to display text field based on keybaord height
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillShow(_ notification: Notification) {
        
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        unowned let weakself = self
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            weakself.centerYConstraint.constant = weakself.orignalCenterYConstraint + keyboardFrame.size.height / 3 ;
        });
    }
    
    /**
     This method will scroll view to previous position when keybaord dismiss
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillHide(_ notification: Notification) {
        self.centerYConstraint.constant = self.orignalCenterYConstraint
    }
    
    //MARK: UITextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
            return false
        }
        else {
            textField.resignFirstResponder()
            //            self.loginButtonAction( nil )
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        if textField == passwordTextField {
        //            if string == ""{
        //                return false
        //            }
        //        }
        return true
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
