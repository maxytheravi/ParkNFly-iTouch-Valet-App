//
//  NewDamagePictureViewController.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 09/02/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
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


@objc protocol DamagePictureTicketUpdateDelegate {
    
    @objc optional func ticketUpdateFromServer()
}

class NewDamagePictureViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DamageMarksViewControllerDelegate {
    
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    @IBOutlet weak var picturesPageControl: UIPageControl!
    @IBOutlet weak var ticketNumberTextField: UITextField!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var fullImageContainerView: UIView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var damageButton: UIButton!
    
    var vehicleDamageBOArray = [VehicleDamageBO]()
    var damageSkeletonImageString: String?
    var selectedIndex: Int = 0
    var imagePickerController: UIImagePickerController?
    var location: String?
    var delegate: DamagePictureTicketUpdateDelegate?
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if naviController?.ticketBO?.vehicleDetails?.damageMarkImage != nil && naviController?.ticketBO?.vehicleDetails?.damageMarkImage != "" {
            self.damageSkeletonImageString = naviController?.ticketBO?.vehicleDetails?.damageMarkImage
        } else {
            if let imgageStream = ObjectiveCCommonMethods.base64forData(UIImageJPEGRepresentation(UIImage(named: "Damage Marks Row Image Copy.jpg")!,0)) {
                self.damageSkeletonImageString = imgageStream
            }
        }
        
        if let _ = naviController?.ticketBO?.vehicleDamages {
            
            for vehicleDamageBO in (naviController?.ticketBO?.vehicleDamages)! {
                self.vehicleDamageBOArray.append(vehicleDamageBO as! VehicleDamageBO)
            }
        }
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberTextField.text = naviController?.ticketBO?.prePrintedTicketNumber
        }else {
            self.ticketNumberTextField.text = naviController?.ticketBO?.barcodeNumberString
        }
        
        var damageCount = 0
        var valuableCount = 0
        for vehicleDamageBO in self.vehicleDamageBOArray {
            
            if vehicleDamageBO.location == "Damage" {
                damageCount += 1
                vehicleDamageBO.imageName = vehicleDamageBO.location! + "\(damageCount)"
            }
            else if vehicleDamageBO.location == "Valuable" {
                valuableCount += 1
                vehicleDamageBO.imageName = vehicleDamageBO.location! + "\(valuableCount)"
            }
        }
        
        self.refreshView()
        
        //Keyboard Done Button
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewDamagePictureViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.notesTextView.inputAccessoryView = numberToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Add observer for Keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewDamagePictureViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewDamagePictureViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Add observer for Keyboard notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func refreshView() {
        
        var vehicleDamageBO:VehicleDamageBO? = nil
        
        if let _ = self.damageSkeletonImageString {
            
            self.picturesPageControl.numberOfPages = self.vehicleDamageBOArray.count + 1
            self.picturesPageControl.currentPage = self.selectedIndex
            
            if self.selectedIndex == 0 {
                
                self.dateTimeLabel.text = " Mark up"
                self.notesTextView.textColor = UIColor.lightGray
                self.notesTextView.text = "Add text here"
                self.notesTextView.isUserInteractionEnabled = false
                self.notesTextView.isHidden = true
                self.location = "Skeleton"
                self.setDamageButtonBackground()
                
                return
                
            } else {
                vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex - 1]
            }
        } else if self.vehicleDamageBOArray.count == 0 {
            
            self.picturesPageControl.numberOfPages = 0
            self.picturesPageControl.currentPage = 0
            
            self.dateTimeLabel.text = ""
            self.notesTextView.textColor = UIColor.lightGray
            self.notesTextView.text = "Add text here"
            self.notesTextView.isUserInteractionEnabled = false
            self.notesTextView.isHidden = false
            self.location = ""
            self.setDamageButtonBackground()
            
            return
            
        } else {
            vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex]
            self.picturesPageControl.numberOfPages = self.vehicleDamageBOArray.count
            self.picturesPageControl.currentPage = self.selectedIndex
        }
        
        self.location = vehicleDamageBO?.location
        
        self.dateTimeLabel.text = " " + (vehicleDamageBO?.imageName)! + " - " + Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(vehicleDamageBO!.reportDateTime!), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyDateTimeFormat())!
        
        self.notesTextView.isUserInteractionEnabled = true
        self.notesTextView.isHidden = false
        
        if vehicleDamageBO!.damageDesc?.characters.count == 0 {
            self.notesTextView.textColor = UIColor.lightGray
            self.notesTextView.text = "Add text here"
        } else {
            self.notesTextView.textColor = UIColor.black
            self.notesTextView.text = vehicleDamageBO!.damageDesc
        }
        
        self.setDamageButtonBackground()
    }
    
    // MARK: Button Actions
    @IBAction func cameraButtonClicked(_ sender:UIButton) {
        
        self.view.endEditing(true)
        
        if sender.tag == 1 {
            self.location = "Damage"
        } else {
            self.location = "Valuable"
        }
        
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController!.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            self.imagePickerController!.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            self.imagePickerController!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        self.imagePickerController!.allowsEditing = false
        self.present(self.imagePickerController!, animated: true, completion: nil)
    }
    
    @IBAction func closeFullImage(_ sender:UIButton) {
        
        self.fullImageContainerView.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.fullImageContainerView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.fullImageContainerView.isHidden = true
        })
    }
    
    // MARK: - UIImagePickerController Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.addImageToArray(image)
        if let _ = self.damageSkeletonImageString {
            self.selectedIndex = self.vehicleDamageBOArray.count
        } else {
            self.selectedIndex = self.vehicleDamageBOArray.count - 1
        }
        self.refreshView()
        self.picturesCollectionView.reloadData()
        
        self.dismiss(animated: true, completion: { () -> Void in
            self.imagePickerController = nil
            self.picturesCollectionView.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.imagePickerController?.dismiss(animated: true, completion: { () -> Void in
            self.imagePickerController = nil
            self.refreshView()
        })
    }
    
    // MARK: - Custom Methods
    func addImageToArray(_ image:UIImage) {
        
        var count = 0
        for vehicleDamageBO in self.vehicleDamageBOArray {
            if vehicleDamageBO.location == self.location {
                count += 1
            }
        }
        count += 1
        
        let vehicleDamageBO = VehicleDamageBO()
        vehicleDamageBO.damageDesc = ""
        vehicleDamageBO.imageName = self.location! + "\(count)"
        vehicleDamageBO.vehicleDamageImage = image
        if let imgageStream = ObjectiveCCommonMethods.base64forData(UIImageJPEGRepresentation(image,0)) {
            vehicleDamageBO.imageStream = imgageStream
        }
        vehicleDamageBO.location = self.location
        vehicleDamageBO.reportDateTime = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())
        vehicleDamageBO.ticketId = Int((naviController?.ticketBO?.ticketID)!)
        self.vehicleDamageBOArray.append(vehicleDamageBO)
    }
    
    func setDamageButtonBackground() {
        
        if naviController?.ticketBO?.vehicleDetails?.damageMarksArray != nil && naviController?.ticketBO?.vehicleDetails?.damageMarksArray?.count > 0 && self.vehicleDamageBOArray.count == 0 {
            self.damageButton.backgroundColor = UIColor.projectThemeRedColor(UIColor())()
        } else if naviController?.ticketBO?.vehicleDetails?.damageMarksArray != nil && naviController?.ticketBO?.vehicleDetails?.damageMarksArray?.count > 0 && self.vehicleDamageBOArray.count > 0 {
            self.damageButton.backgroundColor = UIColor.projectThemeGreenColor(UIColor())()
        } else {
            self.damageButton.backgroundColor = UIColor.projectThemeBlueColor(UIColor())()
        }
    }
    
    func showCurrentImageInFullScreenMode() {
        
        var vehicleDamageBO: VehicleDamageBO? = nil
        
        if let _ = self.damageSkeletonImageString {
            vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex - 1]
        } else {
            vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex]
        }
        
        if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: vehicleDamageBO!.imageStream)){
            self.fullImageView.image = image
        }
        
        self.fullImageContainerView.alpha = 0.0
        self.fullImageContainerView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.fullImageContainerView.alpha = 1.0
        })
    }
    
    func updateDamageMarksImage() {
        
        if naviController?.ticketBO?.vehicleDetails?.damageMarkImage != nil && naviController?.ticketBO?.vehicleDetails?.damageMarkImage != "" {
            self.damageSkeletonImageString = naviController?.ticketBO?.vehicleDetails?.damageMarkImage
        }
        
        self.picturesCollectionView.reloadData()
    }
    
    // MARK: - Button Action Mthods
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        naviController?.ticketBO?.vehicleDamages = NSMutableArray(array: self.vehicleDamageBOArray)
        ActivityLogsManager.sharedInstance.logUserActivity(("All the vehicle damage images are saved successfully " ), logType: "Normal")
        
        var updates = false
        
        if naviController?.ticketBO?.vehicleDamages != nil && naviController?.ticketBO?.vehicleDamages?.count > 0 {
            
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let saveDamagesAndValuablesService: SaveDamagesAndValuablesService = SaveDamagesAndValuablesService()
            saveDamagesAndValuablesService.delegate = self
            saveDamagesAndValuablesService.saveDamagesAndValuablesService(kSaveDamagesAndValuablesService, parameters:["VehicleDamagesArray":(naviController?.ticketBO?.vehicleDamages)!])
            
            updates = true
        }
        
        if naviController?.ticketBO?.vehicleDetails != nil && naviController?.ticketBO?.vehicleDetails?.damageMarksArray != nil && naviController?.ticketBO?.vehicleDetails?.damageMarksArray?.count > 0 {
            
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            
            let updateVehicleInfoService: UpdateVehicleInfoService = UpdateVehicleInfoService()
            updateVehicleInfoService.delegate = self
            updateVehicleInfoService.updateVehicleInfoService(kUpdateVehicleInfoService, parameters: ["VehicleDetailsBO":(naviController?.ticketBO?.vehicleDetails)!, "TicketID":(naviController?.ticketBO?.ticketID)!])
            //            }
            
            updates = true
        }
        
        if updates == false {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func damageButtonAction(_ sender: UIButton) {
        
        //        if let damageMarksArray = naviController?.ticketBO?.vehicleDetails?.damageMarksArray {
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let damageMarksViewController = mainStroyboard.instantiateViewController(withIdentifier: "DamageMarksViewController") as? DamageMarksViewController
        if let damageMarksArray = naviController?.ticketBO?.vehicleDetails?.damageMarksArray {
            damageMarksViewController?.damageMarksArray = damageMarksArray
        }
        damageMarksViewController?.delegate = self
        naviController?.pushViewController(damageMarksViewController!, animated: true)
        //        } else {
        //            let alert = UIAlertController(title: klError, message: "Please add vehicle", preferredStyle: UIAlertControllerStyle.Alert)
        //            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.Default, handler: nil))
        //            self.presentViewController(alert, animated: true, completion: nil)
        //        }
    }
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    // MARK: Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = self.damageSkeletonImageString {
            return self.vehicleDamageBOArray.count + 1
        } else {
            return self.vehicleDamageBOArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.picturesCollectionView.frame.size.width, height: self.picturesCollectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell: PictureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as! PictureCollectionViewCell
        
        cell.imageView.image = nil
        
        if let _ = self.damageSkeletonImageString {
            
            if (indexPath as NSIndexPath).row == 0 {
                
                if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: self.damageSkeletonImageString)){
                    cell.imageView.image = image
                }
                
            } else {
                
                let vehicleDamageBO = self.vehicleDamageBOArray[(indexPath as NSIndexPath).row - 1]
                
                if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: vehicleDamageBO.imageStream)){
                    cell.imageView.image = image
                }
            }
            
        } else {
            
            let vehicleDamageBO = self.vehicleDamageBOArray[(indexPath as NSIndexPath).row]
            
            if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: vehicleDamageBO.imageStream)){
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        if self.damageSkeletonImageString != nil && (indexPath as NSIndexPath).row == 0 {
            self.damageButtonAction(UIButton())
        } else {
            self.showCurrentImageInFullScreenMode()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        for cell: UICollectionViewCell in self.picturesCollectionView.visibleCells {
            if let indexPath = self.picturesCollectionView.indexPath(for: cell) {
                self.selectedIndex = (indexPath as NSIndexPath).row
                self.refreshView()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            for cell: UICollectionViewCell in self.picturesCollectionView.visibleCells {
                if let indexPath = self.picturesCollectionView.indexPath(for: cell) {
                    self.selectedIndex = (indexPath as NSIndexPath).row
                    self.refreshView()
                }
            }
        }
    }
    
    // MARK: UITextView Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        var vehicleDamageBO: VehicleDamageBO? = nil
        
        if let _ = self.damageSkeletonImageString {
            vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex - 1]
        } else {
            vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex]
        }
        
        if vehicleDamageBO!.damageDesc?.characters.count == 0 {
            self.notesTextView.text = ""
        }
        
        self.notesTextView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        var vehicleDamageBO: VehicleDamageBO? = nil
        
        if let _ = self.damageSkeletonImageString {
            vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex - 1]
        } else {
            vehicleDamageBO = self.vehicleDamageBOArray[self.selectedIndex]
        }
        
        if textView.text != "Add text here" {
            vehicleDamageBO!.damageDesc = textView.text
        } else {
            vehicleDamageBO!.damageDesc = ""
        }
        
        if vehicleDamageBO!.damageDesc?.characters.count == 0 {
            self.notesTextView.textColor = UIColor.lightGray
            self.notesTextView.text = "Add text here"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldString = textView.text ?? ""
        let startIndex = oldString.characters.index(oldString.startIndex, offsetBy: range.location)
        let endIndex = oldString.index(startIndex, offsetBy: range.length)
        let newString = oldString.replacingCharacters(in: startIndex ..< endIndex, with: text)
        return newString.characters.count <= 256
    }
    
    // MARK: - Keyboard notifications
    /**
     This method will scroll view to display text field based on keybaord height
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillShow(_ notification: Notification) {
        
        //        var info = notification.userInfo!
        //        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        unowned let weakself = self
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            weakself.view.frame = CGRect(x: 0, y: -100, width: weakself.view.frame.size.width, height: weakself.view.frame.size.height)
        });
    }
    
    /**
     This method will scroll view to previous position when keybaord dismiss
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kUpdateVehicleInfoService as String:
            
            if Utility.sharedInstance.hudCount == 1 {
                
                let alert = UIAlertController(title: klSuccess, message: kSavedSuccessfully, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in
                    _ = self.navigationController?.popViewController(animated: true)
                    self.delegate?.ticketUpdateFromServer!()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            break
            
        case kSaveDamagesAndValuablesService as String:
            
            let vehicleDamages:NSMutableArray? = NSMutableArray(array: response as! [VehicleDamageBO])
            
            let tempVehicleDamagesArray: NSMutableArray? = NSMutableArray()
            if let _ = vehicleDamages {
                vehicleDamages!.enumerateObjects({ vehicleDamageObj, index, stop in
                    tempVehicleDamagesArray!.add((vehicleDamageObj as! VehicleDamageBO).deepCopyOfVehicleDamageBO())
                })
            }
            naviController?.ticketBO?.vehicleDamages = tempVehicleDamagesArray
            
            if let _ = naviController?.ticketBO?.vehicleDamages {
                
                for vehicleDamageBO in (naviController?.ticketBO?.vehicleDamages)! {
                    self.vehicleDamageBOArray.append(vehicleDamageBO as! VehicleDamageBO)
//                    ActivityLogsManager.sharedInstance.logUserActivity(("All the vehicle damage images are saved successfully " ), logType: "Normal")
                }
            }
            
            if Utility.sharedInstance.hudCount == 1 {
                
                let alert = UIAlertController(title: klSuccess, message: kSavedSuccessfully, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in
                    _ = self.navigationController?.popViewController(animated: true)
                    self.delegate?.ticketUpdateFromServer!()
                }
                alert.addAction(okAction)
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
        let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
