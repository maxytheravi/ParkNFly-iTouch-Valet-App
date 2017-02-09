//
//  DamagePictureViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/27/15.
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


class DamagePictureViewController: BaseViewController, DamagePicturesGalleryDelegate, MultipleTicketsViewControllerDelegate {
    
    @IBOutlet weak var ticketNumberTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var carMakeTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Damage Pictures"
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberTextField.text = naviController?.ticketBO?.prePrintedTicketNumber
        }else {
            self.ticketNumberTextField.text = naviController?.ticketBO?.barcodeNumberString
        }
        
        if let _ = naviController?.ticketBO?.vehicleDetails {
            
            if let vehicleTag = naviController?.ticketBO?.vehicleDetails?.licenseNumber {
                self.tagTextField.text = vehicleTag
            } else {
                self.tagTextField.text = ""
            }
            
            self.carMakeTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleMake
            self.carModelTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleModel
        } else {
            
            if let vehicleTag = naviController?.ticketBO?.vehicleDetails?.licenseNumber {
                self.tagTextField.text = vehicleTag
            } else {
                self.tagTextField.text = ""
            }
            
            self.carMakeTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleMake
            self.carModelTextField.text = naviController?.ticketBO?.vehicleDetails?.vehicleModel
        }
    }
    
    // MARK: - Button Action Mthods
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if naviController?.ticketBO?.vehicleDetails == nil {
            naviController?.ticketBO?.vehicleDetails = VehicleDetailsBO()
        }
        
        naviController?.ticketBO?.vehicleDetails?.licenseNumber = self.tagTextField.text
        naviController?.ticketBO?.vehicleDetails?.vehicleMake = self.carMakeTextField.text
        naviController?.ticketBO?.vehicleDetails?.vehicleModel = self.carModelTextField.text
        
        naviController?.ticketBO?.vehicleDetails?.licenseNumber = self.tagTextField.text
        naviController?.ticketBO?.vehicleDetails?.vehicleModel = self.carMakeTextField.text
        naviController?.ticketBO?.vehicleDetails?.vehicleModel = self.carModelTextField.text
        
        if let _ = naviController?.ticketBO?.vehicleDamages {
            
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let saveDamagesAndValuablesService: SaveDamagesAndValuablesService = SaveDamagesAndValuablesService()
            saveDamagesAndValuablesService.delegate = self
            saveDamagesAndValuablesService.saveDamagesAndValuablesService(kSaveDamagesAndValuablesService, parameters:["VehicleDamagesArray":(naviController?.ticketBO?.vehicleDamages)!])
            ActivityLogsManager.sharedInstance.logUserActivity(("All the damage images are saved"), logType: "Normal")
            
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func damageValuablePictursButtonClicked(_ sender: UIButton) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            
            if sender.tag == 1 {
                
                let damagePicturesGallery: DamagePicturesGalleryViewController = Utility.createStoryBoardid(kOnlot).instantiateViewController(withIdentifier: "DamagePicturesGalleryViewController") as! DamagePicturesGalleryViewController
                var vehicleDamageBOArray = [VehicleDamageBO]()
                
                if let _ = naviController?.ticketBO?.vehicleDamages {
                    
                    for vehicleDamageBO in (naviController?.ticketBO?.vehicleDamages)! {
                        
                        if ((vehicleDamageBO as! VehicleDamageBO).location == "Damage" && (vehicleDamageBO as! VehicleDamageBO).imageStream?.characters.count > 0) {
                            
                            if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: (vehicleDamageBO as AnyObject).imageStream)){
                                
                                (vehicleDamageBO as! VehicleDamageBO).vehicleDamageImage = image
                                vehicleDamageBOArray.append(vehicleDamageBO as! VehicleDamageBO)
                            }
                        }
                    }
                }
                
                damagePicturesGallery.vehicleDamageBOArray = vehicleDamageBOArray
                damagePicturesGallery.location = "Damage"
                damagePicturesGallery.delegate = self
                naviController?.pushViewController(damagePicturesGallery, animated: true)
                
            } else if sender.tag == 2 {
                
                let damagePicturesGallery: DamagePicturesGalleryViewController = Utility.createStoryBoardid(kOnlot).instantiateViewController(withIdentifier: "DamagePicturesGalleryViewController") as! DamagePicturesGalleryViewController
                var vehicleDamageBOArray = [VehicleDamageBO]()
                
                if let _ = naviController?.ticketBO?.vehicleDamages {
                    
                    for vehicleDamageBO in (naviController?.ticketBO?.vehicleDamages)! {
                        
                        if ((vehicleDamageBO as! VehicleDamageBO).location == "Valuable" && (vehicleDamageBO as! VehicleDamageBO).imageStream?.characters.count > 0) {
                            
                            if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: (vehicleDamageBO as AnyObject).imageStream)){
                                
                                (vehicleDamageBO as! VehicleDamageBO).vehicleDamageImage = image
                                vehicleDamageBOArray.append(vehicleDamageBO as! VehicleDamageBO)
                            }
                        }
                    }
                }
                
                damagePicturesGallery.vehicleDamageBOArray = vehicleDamageBOArray
                damagePicturesGallery.location = "Valuable"
                damagePicturesGallery.delegate = self
                naviController?.pushViewController(damagePicturesGallery, animated: true)
            }
            
            Utility.sharedInstance.hideHUD()
        }
    }
    
    func makeButtonAction() {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let multipleTicketViewController = mainStroyboard.instantiateViewController(withIdentifier: "MultipleTicketsViewController") as? MultipleTicketsViewController
        multipleTicketViewController?.delegate = self
        multipleTicketViewController!.vehicleMakeArray = naviController?.vehicleMakeArray
        naviController?.pushViewController(multipleTicketViewController!, animated: true)
    }
    
    func modelButtonAction() {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let multipleTicketViewController = mainStroyboard.instantiateViewController(withIdentifier: "MultipleTicketsViewController") as? MultipleTicketsViewController
        multipleTicketViewController?.delegate = self
        let modelArray = ["AWD/4WD", "Convertible", "Coupe", "Hatchback", "Hybrid/Electric", "Luxury", "Sedan", "SUV/CrossOver", "Truck", "Van/Minivan", "Wagon"]
        multipleTicketViewController!.modelArray = modelArray as NSArray
        naviController?.pushViewController(multipleTicketViewController!, animated: true)
    }
    
    // MARK: - Delegate Methods
    func getMakeDetails(_ object: AnyObject) {
        
        let makeDetails = object as? VehicleMakeBO
        self.carMakeTextField.text = makeDetails?.vehicleMakeName as? String
    }
    
    func getModelDetails(_ object: AnyObject) {
        
        self.carModelTextField.text = object as? String
    }
    
    // MARK: - Storyboard Mthods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            
            if segue.identifier == "DamagePicturesGallary" {
                
                let damagePicturesGallery = segue.destination as! DamagePicturesGalleryViewController
                var vehicleDamageBOArray = [VehicleDamageBO]()
                
                for vehicleDamageBO in (naviController?.ticketBO?.vehicleDamages)! {
                    
                    if ((vehicleDamageBO as! VehicleDamageBO).location == "Damage" && (vehicleDamageBO as! VehicleDamageBO).imageStream?.characters.count > 0) {
                        
                        if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: (vehicleDamageBO as AnyObject).imageStream)){
                            
                            (vehicleDamageBO as! VehicleDamageBO).vehicleDamageImage = image
                            vehicleDamageBOArray.append(vehicleDamageBO as! VehicleDamageBO)
                        }
                    }
                }
                
                damagePicturesGallery.location = "Damage"
                damagePicturesGallery.vehicleDamageBOArray = vehicleDamageBOArray
                damagePicturesGallery.delegate = self
                
            } else if segue.identifier == "ValuablePicturesGallary" {
                
                let damagePicturesGallery = segue.destination as! DamagePicturesGalleryViewController
                var vehicleDamageBOArray = [VehicleDamageBO]()
                
                for vehicleDamageBO in (naviController?.ticketBO?.vehicleDamages)! {
                    
                    if ((vehicleDamageBO as! VehicleDamageBO).location == "Valuable" && (vehicleDamageBO as! VehicleDamageBO).imageStream?.characters.count > 0) {
                        
                        if let image = UIImage(data: ObjectiveCCommonMethods.base64Data(from: (vehicleDamageBO as AnyObject).imageStream)){
                            
                            (vehicleDamageBO as! VehicleDamageBO).vehicleDamageImage = image
                            vehicleDamageBOArray.append(vehicleDamageBO as! VehicleDamageBO)
                        }
                    }
                }
                
                damagePicturesGallery.location = "Valuable"
                damagePicturesGallery.vehicleDamageBOArray = vehicleDamageBOArray
                damagePicturesGallery.delegate = self
            }
            
            Utility.sharedInstance.hideHUD()
        }
    }
    
    // MARK: - DamagePicturesGalleryDelegate Mthods
    func getUpdatedDamagePicturesArray(_ vehicleDamageBOArray:[VehicleDamageBO],location:String) {
        
        if let _ = naviController?.ticketBO?.vehicleDamages {
            
            if let innerVehicleDamageBOArray = (naviController?.ticketBO?.vehicleDamages)! as NSArray as? [VehicleDamageBO] {
                var filteredVehicleDamageBOArray = innerVehicleDamageBOArray.filter( { (innerVehicleDamageBO: VehicleDamageBO) -> Bool in
                    return innerVehicleDamageBO.location != location
                })
                
                for vehicleDamageBO in vehicleDamageBOArray{
                    filteredVehicleDamageBOArray.append(vehicleDamageBO)
                }
                
                naviController?.ticketBO?.vehicleDamages = NSMutableArray(array: filteredVehicleDamageBOArray)
            }
            
        } else {
            naviController?.ticketBO?.vehicleDamages = NSMutableArray(array: vehicleDamageBOArray)
        }
    }
    
    // MARK: Should Begin Editing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.carMakeTextField {
            self.makeButtonAction()
        } else if textField == self.carModelTextField {
            self.modelButtonAction()
        } else if textField == self.tagTextField {
            return true
        }
        
        return false
    }
    
    // MARK: Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        let vehicleDamages:NSMutableArray? = NSMutableArray(array: response as! [VehicleDamageBO])
        naviController?.ticketBO?.vehicleDamages = vehicleDamages
        
        let tempVehicleDamagesArray: NSMutableArray? = NSMutableArray()
        if let _ = vehicleDamages {
            vehicleDamages!.enumerateObjects({ vehicleDamageObj, index, stop in
                tempVehicleDamagesArray!.add((vehicleDamageObj as! VehicleDamageBO).deepCopyOfVehicleDamageBO())
            })
        }
        naviController?.ticketBO?.vehicleDamages = tempVehicleDamagesArray
        
        let alert = UIAlertController(title: klSuccess, message: kSavedSuccessfully, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        Utility.sharedInstance.hideHUD()
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
