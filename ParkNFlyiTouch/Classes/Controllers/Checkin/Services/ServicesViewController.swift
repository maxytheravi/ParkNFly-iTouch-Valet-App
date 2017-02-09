//
//  ServicesViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/26/15.
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


class ServicesViewController: BaseViewController, SelectionDelegate, allSelectedServiceDelegate, switchButtonStatusDelegate, SelectedServiceStatusCellDelegate,UITableViewDataSource, UITableViewDelegate {
    
    var selectedCategory:ServiceCategoryBO?
    var serviceDictionary: [String:Array<ServiceBO>]?
    var selectedServiceArray:[ServiceBO]?
    var serviceHistoryCategoryDict = [String:Array<ServiceHistoryBO>]()
    
    @IBOutlet weak var oversizeSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceCategoryTableView: UITableView!
    @IBOutlet weak var serviceHistoryTableView: UITableView!
    @IBOutlet weak var serviceHistoryContainerView: UIView!
    @IBOutlet weak var selectedServicesView: UIView!
    @IBOutlet weak var serviceCategoryButton: UIButton!
    @IBOutlet weak var selectedParticularService: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    weak var currentEditedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Services"
        
        self.serviceDictionary = [String:Array<ServiceBO>]()
        self.selectedServiceArray = [ServiceBO]()
        
        if naviController?.categoryArray == nil {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let getServiceTypeById = GetServiceTypesByFacilityIDService()
            getServiceTypeById.delegate = self
            getServiceTypeById.getServiceTypesByFacilityIDServiceWebservice(kGetServiceTypesByFacilityIDService)
        }
        
        if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
            self.oversizeSwitch.isOn = (naviController?.isOversizeVehicle)!
        } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
            self.oversizeSwitch.isOn = (naviController?.ticketBO?.vehicleDetails?.isOversized)!
        }
        
        if let servicesArray = naviController?.servicesArray {
            self.selectedServiceArray = servicesArray
        }
        
        if let serviceDictionary = naviController?.serviceDictionary {
            self.serviceDictionary = serviceDictionary
        }
        
        let historyButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
        historyButton.setImage(UIImage(named: "History.png"), for: UIControlState())
        historyButton.addTarget(self, action: #selector(ServicesViewController.serviceHistoryButtonAction(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: historyButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        self.serviceHistoryTableView.layer.borderColor = UIColor.projectThemeBlueColor(UIColor())().cgColor
        self.serviceHistoryTableView.layer.borderWidth = 2.0
        self.serviceHistoryTableView.layer.cornerRadius = 5.0
        
        self.reloadSelectedServicesTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.serviceCategoryButton.setTitle("Select Service Category", for: UIControlState())
        self.selectedCategory = nil
        
        //Add observer for Keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateTicketContentViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateTicketContentViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Add observer for Keyboard notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: UIButton action
    @IBAction func selectServiceCategoryButtonAction(_ sender: AnyObject) {
        if naviController?.categoryArray?.count > 0 {
            if self.serviceCategoryTableView.isHidden {
                
                self.serviceCategoryTableView.isHidden = false
                self.serviceCategoryTableView.reloadData()
                
                self.bottomConstraint.constant = self.serviceCategoryTableView.frame.size.height + 10.0;
                self.view.layoutIfNeeded()
                
                self.bottomConstraint.constant = 10.0;
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
                
            } else {
                self.bottomConstraint.constant = self.serviceCategoryTableView.frame.size.height + 10.0;
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: {
                        (value: Bool) in
                        self.serviceCategoryTableView.isHidden = true
                })
            }
        }else {
            let alert = UIAlertController(title: klError, message:kNoServicesAvailable, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectServiceFromSelectedCategory(_ sender: UIButton) {
        
        //check user select service category or not check for selectedCategoryBO
        if self.selectedCategory == nil {
            let alert = UIAlertController(title: klError, message: "Please select service category first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //navigate to serviceCategoryViewController.
            let mainStroyboard = Utility.createStoryBoardid(kMain)
            let selectServiceForCategoryViewController = mainStroyboard.instantiateViewController(withIdentifier: "SelectServiceForCategoryViewController") as? SelectServiceForCategoryViewController
            selectServiceForCategoryViewController?.delegate = self
            var key:String = ""
            if let keyValue = self.selectedCategory?.serviceTypeID {
                key = String(keyValue)
            }
            selectServiceForCategoryViewController?.serviceArray = self.serviceDictionary![key]!
            naviController?.pushViewController(selectServiceForCategoryViewController!, animated: true)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        
        //        let filteredServicesArray = self.selectedServiceArray!.filter( { (serviceBO: ServiceBO) -> Bool in
        //            return serviceBO.isSwitchOn == true
        //        })
        
        if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
            
            naviController?.servicesArray = self.selectedServiceArray
            naviController?.isOversizeVehicle = self.oversizeSwitch.isOn
            
            for serviceDetails in (naviController?.servicesArray)! {
                 ActivityLogsManager.sharedInstance.logUserActivity(("Successfully added " + serviceDetails.serviceName! + " Service"), logType: "Normal")
            }
            
        } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
            
            naviController?.ticketBO?.services = NSMutableArray(array: self.selectedServiceArray!)
            naviController?.ticketBO?.vehicleDetails?.isOversized = self.oversizeSwitch.isOn
            
            for serviceDetails in (naviController?.ticketBO?.services)! {
                ActivityLogsManager.sharedInstance.logUserActivity(("Successfully added " + (serviceDetails as AnyObject).serviceName!! + "Service"), logType: "Normal")
            }
        }
        
        naviController?.serviceDictionary = self.serviceDictionary
        
        _ = naviController?.popViewController(animated: true)
    }
    
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    @IBAction func serviceHistoryButtonAction(_ sender: AnyObject) {
        
        if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
            
            if naviController?.vehicleDetails != nil {
                if naviController?.vehicleDetails?.licenseNumber?.characters.count > 0 || naviController?.vehicleDetails?.vehicleVIN?.characters.count > 0 {
                    
                    if naviController?.vehicleDetails?.vehicleVIN?.characters.count > 0 {
                        
                        Utility.sharedInstance.showHUDWithLabel("Laoding...")
                        
                        let loadServiceHistoryManager:GetServiceHistoryBYTagOrVINService  = GetServiceHistoryBYTagOrVINService()
                        loadServiceHistoryManager.delegate = self
                        loadServiceHistoryManager.getServiceHistoryBYTagOrVINWebService(kServiceHistoryBYTagOrVIN, parameters: ["VIN/Tag": (naviController?.vehicleDetails?.vehicleVIN)!])
                        
                    } else {
                        
                        Utility.sharedInstance.showHUDWithLabel("Laoding...")
                        
                        let loadServiceHistoryManager:GetServiceHistoryBYTagOrVINService  = GetServiceHistoryBYTagOrVINService()
                        loadServiceHistoryManager.delegate = self
                        loadServiceHistoryManager.getServiceHistoryBYTagOrVINWebService(kServiceHistoryBYTagOrVIN, parameters: ["VIN/Tag": (naviController?.vehicleDetails?.licenseNumber)!])
                    }
                } else {
                    let alert = UIAlertController(title: klAlert, message: klPleaseSelectVehicle, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: klAlert, message: klPleaseSelectVehicle, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
            
            if naviController?.ticketBO?.vehicleDetails != nil {
                if naviController?.ticketBO?.vehicleDetails?.licenseNumber?.characters.count > 0 || naviController?.ticketBO?.vehicleDetails?.vehicleVIN?.characters.count > 0 {
                    
                    if naviController?.ticketBO?.vehicleDetails?.vehicleVIN?.characters.count > 0 {
                        
                        Utility.sharedInstance.showHUDWithLabel("Laoding...")
                        
                        let loadServiceHistoryManager:GetServiceHistoryBYTagOrVINService  = GetServiceHistoryBYTagOrVINService()
                        loadServiceHistoryManager.delegate = self
                        loadServiceHistoryManager.getServiceHistoryBYTagOrVINWebService(kServiceHistoryBYTagOrVIN, parameters: ["VIN/Tag": (naviController?.ticketBO?.vehicleDetails?.vehicleVIN)!])
                        
                    } else {
                        
                        Utility.sharedInstance.showHUDWithLabel("Laoding...")
                        
                        let loadServiceHistoryManager:GetServiceHistoryBYTagOrVINService  = GetServiceHistoryBYTagOrVINService()
                        loadServiceHistoryManager.delegate = self
                        loadServiceHistoryManager.getServiceHistoryBYTagOrVINWebService(kServiceHistoryBYTagOrVIN, parameters: ["VIN/Tag": (naviController?.ticketBO?.vehicleDetails?.licenseNumber)!])
                    }
                } else {
                    let alert = UIAlertController(title: klAlert, message: klPleaseSelectVehicle, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: klAlert, message: klPleaseSelectVehicle, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .cancel) { (action) in }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        ActivityLogsManager.sharedInstance.logUserActivity(("Service history button is tapped"), logType: "Normal")
    }
    
    @IBAction func serviceHistoryCloseButtonAction(_ sender: AnyObject) {
//        self.serviceHistoryContainerView.hidden = true
        
        self.serviceHistoryContainerView.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.serviceHistoryContainerView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.serviceHistoryContainerView.isHidden = true
        })
    }
    
    @IBAction func oversizedSwitchButtonAction(_ sender: AnyObject) {
        
        if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
            naviController?.isOversizeVehicle = self.oversizeSwitch.isOn
        } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
            naviController?.ticketBO?.vehicleDetails?.isOversized = self.oversizeSwitch.isOn
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ServiceCategorySegue" {
            let serviceCategoryTableView = segue.destination as! SelectionViewController
            serviceCategoryTableView.serviceCategoryArray = (naviController?.categoryArray)!
            serviceCategoryTableView.delegate = self
        }
    }
    
    // MARK: SelectionDelegate methods
    func getSelectedServiceCategory(_ selectedServiceCategory:ServiceCategoryBO) {
        //Update serviceCategoryButton name
        self.serviceCategoryButton.setTitle(selectedServiceCategory.serviceTypeName, for: UIControlState())
        self.selectedCategory = selectedServiceCategory
        self.callGetProductSetAddonTypeAPI()
    }
    
    func callGetProductSetAddonTypeAPI() {
        
        var key:String = ""
        if let keyValue = self.selectedCategory?.serviceTypeID {
            key = String(keyValue)
        }
        
        if let _ = self.serviceDictionary![key] {
            
        } else {
            callWebService()
        }
    }
    
    func callWebService() {
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let getProduct = GetProductSetAddonTypeService()
        getProduct.delegate = self
        
        var key:String = ""
        if let keyValue = self.selectedCategory?.serviceTypeID {
            key = String(keyValue)
        }
        getProduct.getProductSetAddonTypeWebService(kGetProductSetAddonTypeService, parameters: ["ServiceTypeID":key])
    }
    
    // MARK : switchButtonStatusDelegate method
    func getSwitchButtonStatus(_ status:Bool, forServiceID:Int) {
        
        for key in self.serviceDictionary!.keys {
            let servicesArray = self.serviceDictionary![key]
            for service in servicesArray! {
                if service.serviceID == forServiceID
                {
                    service.isSwitchOn = status
                }
            }
            self.serviceDictionary![key] = servicesArray
        }
        
        self.reloadSelectedServicesTableView()
    }
    
    func serviceStatusUpdated() {
        
    }
    
    // MARK: allSelectedServiceDelegate methods
    func getAllSelectedServiceDetail(_ selectedServiceArray:[ServiceBO]) {
        var key:String = ""
        if let keyValue = self.selectedCategory?.serviceTypeID {
            key = String(keyValue)
        }
        self.serviceDictionary![key] = selectedServiceArray
        
        self.reloadSelectedServicesTableView()
    }
    
    func reloadSelectedServicesTableView() {
        //first remove all data from self.selectedServiceArray and assign all services which has isServiceSelected == true
        self.selectedServiceArray?.removeAll()
        for key in self.serviceDictionary!.keys {
            let servicesArray = self.serviceDictionary![key]
            for service in servicesArray! {
                if service.isServiceSelected == true {
                    self.selectedServiceArray?.append(service)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.serviceHistoryTableView {
            return serviceHistoryCategoryDict.keys.count
        }
        return 1
    }
    
    //    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        if tableView == self.serviceHistoryTableView {
    //            let dictKeys = [String](serviceHistoryCategoryDict.keys)
    //            let dateStr = dictKeys[section]
    //            return "   " + Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(dateStr), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyDateFormat())!
    //        }
    //        return nil
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.serviceHistoryTableView {
            
            let header: String = "customHeader"
            var vHeader: UITableViewHeaderFooterView?
            vHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: header)
            if vHeader == nil {
                vHeader = UITableViewHeaderFooterView(reuseIdentifier: header)
                //                vHeader!.textLabel!.backgroundColor = UIColor.redColor()
            }
            
            let dictKeys = [String](serviceHistoryCategoryDict.keys)
            let dateStr = dictKeys[section]
            vHeader!.textLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            vHeader!.textLabel!.text = "  " + Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(dateStr), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyDateFormat())!
            
            return vHeader
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            self.selectedServicesView.isHidden = self.selectedServiceArray?.count == 0
            return (self.selectedServiceArray?.count)!
        } else if tableView == self.serviceCategoryTableView {
            return (naviController?.categoryArray == nil ? 0 : (naviController?.categoryArray)!.count)
        } else if tableView == self.serviceHistoryTableView {
            let dateStr = [String](serviceHistoryCategoryDict.keys)[section]
            return (serviceHistoryCategoryDict[dateStr]?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            //            if naviController?.currentFlowStatus == FlowStatus.kCheckInFlow {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedServiceCell") as! ShowSelectedServiceTableViewCell
            let serviceBO:ServiceBO = self.selectedServiceArray![(indexPath as NSIndexPath).row]
            cell.delegate = self
            cell.configureCell(serviceBO,serviceVC: self, indexPath: indexPath as IndexPath)
            return cell
            
            //            } else if naviController?.currentFlowStatus == FlowStatus.kOnLotFlow {
            //
            //                let cell = tableView.dequeueReusableCellWithIdentifier("SelectedServiceStatusCell") as! ShowSelectedServiceStatusTableViewCell
            //                let serviceBO:ServiceBO = self.selectedServiceArray![indexPath.row]
            //                cell.delegate = self
            //                cell.configureCell(serviceBO)
            //                return cell
            //
            //            } else {
            //                return UITableViewCell()
            //            }
            
        } else if tableView == self.serviceCategoryTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCategoryCell") as! ServiceCategoryCell
            let serviceCategoryBO:ServiceCategoryBO = (naviController?.categoryArray)![(indexPath as NSIndexPath).row]
            cell.configureCell(serviceCategoryBO)
            return cell
            
        } else if tableView == self.serviceHistoryTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
            let dateStr = [String](serviceHistoryCategoryDict.keys)[(indexPath as NSIndexPath).section]
            let serviceHistoryBO = serviceHistoryCategoryDict[dateStr]![(indexPath as NSIndexPath).row]
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
            cell.textLabel?.text = serviceHistoryBO.category! + " - " + serviceHistoryBO.serviceName!
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            
        } else if tableView == self.serviceCategoryTableView {
            
            self.getSelectedServiceCategory((naviController?.categoryArray)![(indexPath as NSIndexPath).row])
            self.view.layoutIfNeeded()
            
            self.bottomConstraint.constant = self.serviceCategoryTableView.frame.size.height + 10.0;
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                }, completion: {
                    (value: Bool) in
                    self.serviceCategoryTableView.isHidden = true
            })
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == self.tableView {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                let serviceBO = self.selectedServiceArray![(indexPath as NSIndexPath).row]
                serviceBO.isServiceSelected = false
                serviceBO.serviceNotes = ""
                self.selectedServiceArray?.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            }
        }
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard notifications
    /**
     This method will scroll view to display text field based on keybaord height
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillShow(_ notification: Notification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let frame = self.currentEditedTextField?.convert((self.currentEditedTextField?.frame)!, to: self.view)
        
        if frame?.origin.y > keyboardHeight {
            unowned let weakself = self
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                weakself.view.frame = CGRect(x: 0, y: (keyboardHeight - (frame?.origin.y)!), width: weakself.view.frame.size.width, height: weakself.view.frame.size.height)
            });
        }
    }
    
    /**
     This method will scroll view to previous position when keybaord dismiss
     
     :param: sender  The object that triggered the action
     :returns: Void returns nothing
     */
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch identifier {
        case kGetServiceTypesByFacilityIDService as String :
            
            naviController?.categoryArray = response as? [ServiceCategoryBO]
            
            break
            
        case kGetProductSetAddonTypeService as String :
            
            var key:String = ""
            if let keyValue = self.selectedCategory?.serviceTypeID {
                key = String(keyValue)
            }
            self.serviceDictionary![key] = response as? Array<ServiceBO>
            
            break
            
        case kServiceHistoryBYTagOrVIN as String:
            
            //            let mainStroyboard = Utility.createStoryBoardid(kMain)
            //            let serviceaHistroyViewController = mainStroyboard.instantiateViewControllerWithIdentifier("ServiceHistoryViewController") as? ServiceHistoryViewController
            //            let serviceHistoryBOArray: [ServiceHistoryBO] = (response as? [ServiceHistoryBO])!
            //            serviceaHistroyViewController!.serviceHistoryCategoryDict = self.arrangeServiceHistoryByDateCategory(serviceHistoryBOArray)
            //            naviController?.pushViewController(serviceaHistroyViewController!, animated: true)
            
            let serviceHistoryBOArray: [ServiceHistoryBO] = (response as? [ServiceHistoryBO])!
            self.serviceHistoryCategoryDict = self.arrangeServiceHistoryByDateCategory(serviceHistoryBOArray)
            self.serviceHistoryTableView.reloadData()
//            self.serviceHistoryContainerView.hidden = false
            
            self.serviceHistoryContainerView.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.serviceHistoryContainerView.alpha = 1.0
                }, completion: {
                    (value: Bool) in
                    self.serviceHistoryContainerView.isHidden = false
            })
            
            break
            
        default:
            break
        }
        
        Utility.sharedInstance.hideHUD()
    }
    
    func arrangeServiceHistoryByDateCategory(_ serviceHistoryArray:[ServiceHistoryBO]) -> [String:Array<ServiceHistoryBO>] {
        
        var serviceHistoryCategoryDict = [String:Array<ServiceHistoryBO>]()
        
        for serviceHistoryBO in serviceHistoryArray {
            
            var serviceHistoryBOArray = serviceHistoryCategoryDict[serviceHistoryBO.dateOfService!]
            
            if serviceHistoryBOArray == nil {
                serviceHistoryBOArray = [ServiceHistoryBO]()
            }
            
            serviceHistoryBOArray?.append(serviceHistoryBO)
            serviceHistoryCategoryDict[serviceHistoryBO.dateOfService!] = serviceHistoryBOArray
        }
        
        return serviceHistoryCategoryDict
    }
    
    func didFailedWithError(_ identifier: NSString, errorMessage: NSString) {
        
        Utility.sharedInstance.hideHUD()
        
        switch identifier {
            
        case kGetServiceTypesByFacilityIDService as String:
            
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        case kGetProductSetAddonTypeService as String:
            
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
            
        default:
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
        }
    }
}
