//
//  MaintenanceViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 3/16/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class MaintenanceViewController: BaseViewController {
    
    @IBOutlet var passcodeLabel : [UILabel]!
    @IBOutlet var wrongPasscodeButton : UIButton!
    @IBOutlet var passcodeContainer : UIView!
    @IBOutlet var serverNameTextField : UITextField!
    @IBOutlet var deviceNameTextField : UITextField!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.wrongPasscodeButton.layer.cornerRadius = 5
        
//        if let serverName = Keychain.getStringForKey("ServerName") {
//            self.serverNameTextField.text = serverName
//        }
        
        if let serverName = UserDefaults.standard.object(forKey: "ServerName") , !(UserDefaults.standard.object(forKey: "ServerName") as! String).isEmpty {
            self.serverNameTextField.text = serverName as? String
        }
        
//        if let deviceName = Keychain.getStringForKey("DeviceName") {
//            self.deviceNameTextField.text = deviceName
//        }
        
        if let deviceName = UserDefaults.standard.object(forKey: "DeviceName") , !(UserDefaults.standard.object(forKey: "DeviceName") as! String).isEmpty {
            self.deviceNameTextField.text = deviceName as? String
        }
    }
    
    // MARK: - Button Actions
    @IBAction func keyboardButtonClicked(_ button: UIButton) {
        
        if button.tag == 11 {
            if  self.index > 0 {
                self.index -= 1
                let passcodeLab = self.passcodeLabel[self.index]
                passcodeLab.text = "-"
            }
            
            _ = self.getPasscodeValue()
            
            return
        }
        
        if self.index == 5 {
            self.index = 0
            for passcodeLab in self.passcodeLabel {
                passcodeLab.text = "-"
            }
        }
        
        let passcodeLab = self.passcodeLabel[self.index]
        passcodeLab.text = "\(button.tag)"
        
        self.index += 1
        
        if self.index == 5 {
            
            if self.getPasscodeValue() == kPasscode {
                
                self.passcodeContainer.alpha = 1.0
                UIView.animate(withDuration: 0.3, animations: {
                    self.passcodeContainer.alpha = 0.0
                    }, completion: {
                        (value: Bool) in
                        self.passcodeContainer.isHidden = true
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                    self.clearPasscode()
                }
                
                self.wrongPasscodeButton.isHidden = false
                self.wrongPasscodeButton.alpha = 1.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.wrongPasscodeButton.alpha = 0.0
                        }, completion: {
                            (value: Bool) in
                            self.wrongPasscodeButton.isHidden = true
                    })
                }
            }
        }
        
        _ = self.getPasscodeValue()
    }
    
    @IBAction func backButtonClicked(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ button: UIButton) {
        
        if self.serverNameTextField.text?.characters.count != 0 && self.deviceNameTextField.text?.characters.count != 0 {
            
            naviController!.clearDataOnServerChanged()
            
//            Keychain.saveString(self.serverNameTextField.text, forKey: "ServerName")
            UserDefaults.standard.set(self.serverNameTextField.text, forKey: "ServerName")
//            Keychain.saveString(self.deviceNameTextField.text, forKey: "DeviceName")
            UserDefaults.standard.set(self.deviceNameTextField.text, forKey: "DeviceName")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
//            Utility.sharedInstance.loginViewController?.callGetiTouchConfigWebServices()
            
        } else {
            let alert = UIAlertController(title: klError, message: "Invalid inputs", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Custom Methods
    func getPasscodeValue() -> Int {
        
        var passcode = ""
        for label in self.passcodeLabel {
            if label.text != "-" {
                passcode = passcode + label.text!
            }
        }
        
        passcode = passcode.characters.count > 0 ? passcode : "0"
        
        return Int(passcode)!
    }
    
//    func animateTextFieldsForWrongCredentials() {
//        
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.07
//        animation.repeatCount = 2
//        animation.autoreverses = true
//        
//        //adding animation for username textfield
//        animation.fromValue = NSValue(CGPoint: CGPointMake(usernameTextField.center.x - 10, usernameTextField.center.y))
//        animation.toValue = NSValue(CGPoint: CGPointMake(usernameTextField.center.x + 10, usernameTextField.center.y))
//        usernameTextField.layer.addAnimation(animation, forKey: "position")
//    }
    
    func clearPasscode() {
        self.index = 0
        for passcodeLab in self.passcodeLabel {
            passcodeLab.text = "-"
        }
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
