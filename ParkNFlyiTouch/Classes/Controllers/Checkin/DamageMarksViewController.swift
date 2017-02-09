//
//  DamageMarksViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 24/12/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol DamageMarksViewControllerDelegate {
    
    @objc optional func updateDamageMarksImage()
}

class DamageMarksViewController: BaseViewController {
    
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var damageMarkDetailsContainerView: UIView!
    @IBOutlet weak var damageMarkDetailsView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var logDate: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var damageMarksArray: [DamageMarkBO]?
    var selectedDamageMarkIndex: Int = 0
    var damageMarkSize: CGFloat = 20.0
    var delegate: DamageMarksViewControllerDelegate?
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        if self.damageMarksArray == nil {
            self.damageMarksArray = [DamageMarkBO]()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DamageMarksViewController.handleTap(_:)))
        self.vehicleImageView.addGestureRecognizer(tap)
        
        self.noteTextView.layer.borderWidth = 0.5
        self.noteTextView.layer.cornerRadius = 10.0
        self.noteTextView.layer.masksToBounds = true
        self.noteTextView.layer.borderColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0).cgColor
        
        self.damageMarkDetailsView.layer.borderWidth = 2.0
        self.damageMarkDetailsView.layer.cornerRadius = 0
        self.damageMarkDetailsView.layer.masksToBounds = true
        self.damageMarkDetailsView.layer.borderColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor
        
        self.damageMarkDetailsContainerView.isHidden = true
        
        //Keyboard Done Button
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DamageMarksViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.noteTextView.inputAccessoryView = numberToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.drawDamageMarkedButtons()
    }
    
    func drawDamageMarkedButtons() {
        
        for view: UIView in self.vehicleImageView.subviews {
            view.removeFromSuperview()
        }
        
        var index = 0
        for damageMarkBO in self.damageMarksArray! {
            
            index += 1
            
            let button =  UIButton(type: UIButtonType.system)
            button.addTarget(self, action: #selector(DamageMarksViewController.damageMarkTapped(_:)), for: UIControlEvents.touchUpInside)
            button.frame = CGRect(x: (damageMarkBO.locationX! - damageMarkSize/2.0), y: (damageMarkBO.locationY! - damageMarkSize/2.0), width: damageMarkSize, height: damageMarkSize)
            
            if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
                
                button.backgroundColor = (damageMarkBO.damageID != nil) ? (damageMarkBO.status == false ? UIColor.red : UIColor.yellow) : (damageMarkBO.status == false ? UIColor.red : UIColor.green)
                
            } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
                
                button.backgroundColor = (damageMarkBO.damageID != nil) ? (damageMarkBO.status == false ? UIColor.red : (damageMarkBO.ticketBarcode == naviController?.ticketBO?.barcodeNumberString ? UIColor.green : UIColor.yellow)) : (damageMarkBO.status == false ? UIColor.red : UIColor.green)
            }
            
            button.tag = index
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = 1.5
            self.vehicleImageView.addSubview(button)
        }
    }
    
    override func popingViewController() {
        naviController?.isNavigationBarHidden = false
    }
    
    // MARK: Button Actions
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    @IBAction func clearButtonAction(_ sender: AnyObject) {
        
//        self.damageMarksArray?.removeAll()
        
        self.damageMarksArray = self.damageMarksArray!.filter( { (damageMarkBO: DamageMarkBO) -> Bool in
            return damageMarkBO.damageID != nil
        })
        
        self.drawDamageMarkedButtons()
    }
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        
        if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
            naviController?.vehicleDetails?.damageMarksArray = self.damageMarksArray
            
            for damageMarkDetails in (naviController?.vehicleDetails?.damageMarksArray)! {
                
                if damageMarkDetails.damageID == nil {
                    ActivityLogsManager.sharedInstance.logUserActivity(("Successfully added damge mark by : " + damageMarkDetails.markedBy! + " on : " + damageMarkDetails.logDate! + " at : " + (damageMarkDetails.locationX?.description)! + ", " + (damageMarkDetails.locationY?.description)! + ""), logType: "Normal")
                }
            }
            
        } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
            naviController?.ticketBO?.vehicleDetails?.damageMarksArray = self.damageMarksArray
            
            for damageMarkDetails in (naviController?.ticketBO?.vehicleDetails?.damageMarksArray)! {
                
                if damageMarkDetails.damageID == nil {
                    ActivityLogsManager.sharedInstance.logUserActivity(("Successfully added damge mark by : " + damageMarkDetails.markedBy! + " on : " + damageMarkDetails.logDate! + " at : " + (damageMarkDetails.locationX?.description)! + ", " + (damageMarkDetails.locationY?.description)! + ""), logType: "Normal")
                }
            }
        }
        
        for view in self.vehicleImageView.subviews {
            let damageMarkBO = self.damageMarksArray![view.tag - 1]
//            view.backgroundColor = UIColor.yellowColor()
            if damageMarkBO.status == false {
                view.isHidden = true
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(self.vehicleImageView.frame.size, true, 0.0)
        self.vehicleImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        if let data = UIImageJPEGRepresentation(screenshot,0) {
//            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//            let documentsDirectory = paths[0]
//            let filename = (documentsDirectory as NSString).stringByAppendingPathComponent("copy.jpg")
//            data.writeToFile(filename, atomically: true)
//        }
        
        if let imgageStream = ObjectiveCCommonMethods.base64forData(UIImageJPEGRepresentation(screenshot!,0)) {
            if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
                naviController?.vehicleDetails?.damageMarkImage = imgageStream
            } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
                naviController?.ticketBO?.vehicleDetails?.damageMarkImage = imgageStream
                if self.delegate?.updateDamageMarksImage != nil {
                    self.delegate?.updateDamageMarksImage!()
                }
            }
        }
        
        for view in self.vehicleImageView.subviews {
//            let damageMarkBO = self.damageMarksArray![view.tag - 1]
            view.isHidden = false
//            view.backgroundColor = (damageMarkBO.damageID != nil) ? (damageMarkBO.status == false ? UIColor.redColor() : UIColor.yellowColor()) : (damageMarkBO.status == false ? UIColor.redColor() : UIColor.greenColor())
        }
        
        _ = naviController!.popViewController(animated: true)
        
//        Utility.sharedInstance.showHUDWithLabel("Loading...")
//        let updateVehicleInfoService: UpdateVehicleInfoService = UpdateVehicleInfoService()
//        updateVehicleInfoService.delegate = self
//        updateVehicleInfoService.updateVehicleInfoService(kUpdateVehicleInfoService, parameters: ["VehicleDetailsBO":(naviController?.vehicleDetails)!])
    }
    
    @IBAction func damageMarkTapped(_ button: UIButton) {
        
        self.damageMarkDetailsContainerView.isHidden = false
        self.selectedDamageMarkIndex = button.tag
        
        let damageMarkBO: DamageMarkBO = self.damageMarksArray![self.selectedDamageMarkIndex - 1]
        
        self.userName.text = naviController?.userName
        
        self.logDate.text = Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(damageMarkBO.logDate!), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyDateTimeFormat())
        
        self.noteTextView.text = damageMarkBO.note
        
        if damageMarkBO.status == false {
            self.deleteButton.setTitle("Restore", for: UIControlState())
            self.deleteButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
        } else {
            self.deleteButton.setTitle("Remove", for: UIControlState())
            self.deleteButton.backgroundColor = UIColor.projectThemeRedColor(UIColor())()
        }
    }
    
    @IBAction func removeDamageMarkDetailsView(_ button: UIButton) {
        
        self.view.endEditing(true)
        self.damageMarkDetailsContainerView.isHidden = true
        self.selectedDamageMarkIndex = 0
    }
    
    @IBAction func saveDamageMarkDetailsButtonAction(_ button: UIButton) {
        
        self.damageMarksArray![self.selectedDamageMarkIndex - 1].note = self.noteTextView.text
        
        self.view.endEditing(true)
        self.damageMarkDetailsContainerView.isHidden = true
        self.selectedDamageMarkIndex = 0
    }
    
    // MARK: UITextView Methods
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldString = textView.text ?? ""
        let startIndex = oldString.characters.index(oldString.startIndex, offsetBy: range.location)
        let endIndex = oldString.index(startIndex, offsetBy: range.length)
        let newString = oldString.replacingCharacters(in: startIndex ..< endIndex, with: text)
        return newString.characters.count <= 1000
    }
    
    @IBAction func deleteDamageMarkButtonAction(_ button: UIButton) {
        
//        self.damageMarksArray?.removeAtIndex(self.selectedDamageMarkIndex - 1)
        let damageMarkBO = self.damageMarksArray![self.selectedDamageMarkIndex - 1]
        
        damageMarkBO.status = damageMarkBO.status == true ? false : true
        
        /*if let _ = damageMarkBO.damageID {
            damageMarkBO.status = damageMarkBO.status == true ? false : true
        } else {
            self.damageMarksArray?.removeAtIndex(self.selectedDamageMarkIndex - 1)
        }*/
        
        self.view.endEditing(true)
        self.damageMarkDetailsContainerView.isHidden = true
        self.selectedDamageMarkIndex = 0
        
        self.drawDamageMarkedButtons()
    }
    
    // MARK: UITapGestureRecognizer Action
    func handleTap(_ tapRecognizer: UITapGestureRecognizer) {
        
        let location = tapRecognizer.location(in: self.vehicleImageView)
        
        let damageMarkBO = DamageMarkBO()
        damageMarkBO.locationX = location.x
        damageMarkBO.locationY = location.y
        damageMarkBO.markedBy = naviController!.userName
        damageMarkBO.logDate = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())
        damageMarkBO.note = ""
        damageMarkBO.status = true
        self.damageMarksArray?.append(damageMarkBO)
        
        self.drawDamageMarkedButtons()
        
//        self.damageMarkTapped(self.vehicleImageView.viewWithTag(self.damageMarksArray!.count) as! UIButton)
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kUpdateVehicleInfoService as String:
            
            _ = self.navigationController?.popViewController(animated: true)
            
            break
            
        default:
            break
        }
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
