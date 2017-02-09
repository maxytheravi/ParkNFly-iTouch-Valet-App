//
//  BaseNavigationController.swift
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


class BaseNavigationController: UINavigationController, DTDeviceDelegate {
    
    //App flow dependent
    var currentFlowStatus: FlowStatus?
    
    //Login dependent
    var authenticateUser: String?
    var ticketNumber: String?
    var priprintedNumber: String?
    var ticketFromServerPrintDateTime: String?
    var ticketFromServerTicketID: String?
    var shiftCode: String?
    var userName: String?
    var isTicketFromServer: Bool = false
    var isReservationSearched: Bool = false
    var creditCardInfo: CreditCardInfoBO?
    
    //Functionality dependent
    var updatedParkingTypeID:Int?
    var updatedParkingTypeName:String?
    var updatedDate:String?
    var updatedTime:String?
    var updatedFirstName:String? = ""
    var updatedLastName:String? = ""
    var phoneNumber: String? = ""
    
    //Server selection dependent
    var facilityConfig: FacilityConfigBO?
    var vehicleMakeArray:[VehicleMakeBO]?
    var productArray:[ProductSetServiceBO]?
    var allLocationArray:[LocationBO]?
    var deviceIdByDeviceByDeviceAddress: DeviceIdByDeviceAddressBO?
    var autoCloseShiftRequired = false
    var autoCloseShiftTimeOutInMinutes = 60
    var autoCloseShiftUserName = "SYSTEM"
    
    //Data loading dependent
    var ticketBO: TicketBO?
    //    var updateTicketBO: TicketBO?
    
    //Checkin dependent
    var reservationDetails:ReservationAndFPCardDetailsBO?
    //    var fpCardDetails:ReservationAndFPCardDetailsBO?
    var contractCardDetails: ContractCardInfoBO?
    var servicesArray:[ServiceBO]?
    var categoryArray:[ServiceCategoryBO]?
    var serviceDictionary: [String:Array<ServiceBO>]?
    var isOversizeVehicle:Bool = false
    var vehicleDetails: VehicleDetailsBO?
    
    //App launch dependent
    var dtdev: DTDevices?
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dtdev = DTDevices.sharedDevice() as? DTDevices
        dtdev!.addDelegate(self)
    }
    
    // MARK: Clear data methods
    func clearAllData() {
        self.clearDataOnServerChanged()
    }
    
    func clearDataOnServerChanged() {
        
        self.clearDataOnLoggedOut()
        
        categoryArray = nil
        serviceDictionary = nil
        facilityConfig = nil
        vehicleMakeArray = nil
        productArray = nil
        allLocationArray = nil
        deviceIdByDeviceByDeviceAddress = nil
        
        autoCloseShiftRequired = false
        autoCloseShiftTimeOutInMinutes = 60
        autoCloseShiftUserName = "SYSTEM"
    }
    
    func clearDataOnLoggedOut() {
        
        self.clearDataOnAppFlowChanged()
        
        authenticateUser = nil
        shiftCode = nil
        userName = nil
    }
    
    func clearDataOnAppFlowChanged() {
        
        self.clearDataOnExitCheckin()
        
        ticketNumber = nil
        priprintedNumber = nil
        isTicketFromServer = false
        isReservationSearched = false
        ticketFromServerPrintDateTime = nil
        ticketFromServerTicketID = nil
        creditCardInfo = nil
        
        ticketBO = nil
        self.clearDataOnExitCheckout()
        
        updatedParkingTypeID = nil
        updatedParkingTypeName = nil
        updatedDate = nil
        updatedTime = nil
        updatedFirstName = nil
        updatedLastName = nil
        phoneNumber = nil
        contractCardDetails = nil
        
        self.updateServiceSelectionStatus()
    }
    
    func updateServiceSelectionStatus() {
        
        if let _ = self.serviceDictionary {
            for key in (self.serviceDictionary?.keys)! {
                let services: [ServiceBO] = self.serviceDictionary![key]!
                for serviceBO in services {
                    serviceBO.isServiceSelected = false
                    serviceBO.serviceCompleted = "ToBeDone"
                    serviceBO.cashierUserName = ""
                    serviceBO.serviceNotes = ""
                }
            }
        }
    }
    
    func clearDataOnExitCheckin() {
        reservationDetails = nil
        //        fpCardDetails = nil
        isOversizeVehicle = false
        vehicleDetails = nil
        servicesArray = nil
    }
    
    func clearDataOnExitCheckout() {
        //        updateTicketBO = nil
    }
    
    func clearDataForLookup() {
        ticketBO = nil
        //        fpCardDetails = nil
        reservationDetails = nil
        contractCardDetails = nil
        //        updatedFirstName = nil
        //        updatedLastName = nil
        //        updatedParkingTypeName = nil
        //        updatedParkingTypeID = nil
        //        updatedDate = nil
        //        updatedTime = nil
        //        phoneNumber = nil
    }
    
    // MARK: Common general methods
    func getParkingTypeIDFromParkingTypeName(_ parkingTypeName: String) -> Int {
        
        if productArray == nil {
            return 0
        }
        let filteredProductArray: [ProductSetServiceBO] = productArray!.filter { (product : ProductSetServiceBO) -> Bool in
            return product.parkingTypeName == parkingTypeName
        }
        if filteredProductArray.count == 0 {
            return 0
        }
        let product: ProductSetServiceBO = filteredProductArray.last!
        
        return product.parkingTypeID!
    }
    
    func getParkingTypeNameFromParkingTypeID(_ parkingTypeID: Int) -> String {
        
        if productArray == nil {
            return ""
        }
        let filteredProductArray: [ProductSetServiceBO] = productArray!.filter { (product : ProductSetServiceBO) -> Bool in
            return product.parkingTypeID == parkingTypeID
        }
        if filteredProductArray.count == 0 {
            return ""
        }
        let product: ProductSetServiceBO = filteredProductArray.last!
        
        return product.parkingTypeName!
    }
    
     @nonobjc func updateDetailsFromReservationAndFPCardDetailsBO(_ reservationDetails: ReservationAndFPCardDetailsBO?) {
        
        if let _ = reservationDetails {
            
            naviController?.updatedFirstName = reservationDetails?.firstName
            naviController?.updatedLastName = reservationDetails?.lastName
            
            if reservationDetails?.parkingType != nil && reservationDetails?.parkingType > 0 {
                naviController?.updatedParkingTypeName = reservationDetails?.parkingTypeName
                naviController?.updatedParkingTypeID = reservationDetails?.parkingType
            }
            
            let date: String? = Utility.getFormatedDateBeforeT((reservationDetails?.toDate)! as String)
            if date != nil && date != "" {
                naviController?.updatedDate = date
            }
            
            let time: String? = Utility.getFormatedTimeAfterT((reservationDetails?.toDate)! as String)
            if time != nil && time != "" {
                naviController?.updatedTime = time
            }
            
            if reservationDetails?.phoneNumber != nil && reservationDetails?.phoneNumber > 0 {
                naviController?.phoneNumber = "\((reservationDetails?.phoneNumber)!)"
            }
        }
    }
    
    func updateDetailsFromTicketBO(_ ticketBO: TicketBO?) {
        
        if let _ = ticketBO {
            
            naviController?.updatedFirstName = ticketBO?.firstName
            naviController?.updatedLastName = ticketBO?.lastName
            naviController?.updatedParkingTypeName = ticketBO?.parkingTypeName
            naviController?.updatedParkingTypeID = Int((ticketBO?.parkingType)!)
            naviController?.updatedDate = Utility.getFormatedDateBeforeT((ticketBO?.toDateValetScan)!)
            naviController?.updatedTime = Utility.getFormatedTimeAfterT((ticketBO?.toDateValetScan)!)
            naviController?.phoneNumber = ticketBO?.phoneNo
        }
    }
    
    // MARK: DTDEV Methods (IPC Machine)
    func magneticCardData(_ track1: String, track2: String, track3: String) {
        
        //        UIAlertView(title: "magneticCardData", message: "track1:\(track1),\ntrack2:\(track2),\ntrack3:\(track3)", delegate: nil, cancelButtonTitle: "OK").show()
        
        //Loyalty Card
        //track1 = ""
        //track2 = ";3085280010000292692=1201000?"
        //track3 = ""
        
        //Visa Card
        //track1 = "%B4386280025173604^RAVI KARADBHAJNE          ^1805206136040000000000504000001?"
        //track2 = ";4386280025173604=18052061360450400001?"
        //track3 = ""
        
        //Master Card
        //track1 = "%B5497677007222708^                          ^200422612708          441      ?"
        //track2 = ;5497677007222708=20042261270844130006?
        //track3 = ;0015497777563533670015=0000000300030000900016002708020000020040=0000000000000=0000000000000=0=0000000000?
        
        //        let file = "track.txt" //this is the file. we will write to and read from it
        //
        //        let text = "aaa\(track1)aaa\n\n\n\n\n" + "aaa\(track2)aaa\n\n\n\n\n" + "aaa\(track3)aaa"
        //
        //        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        //
        //            let path = dir.appendingPathComponent(file)
        //            print(path)
        //
        //            //writing
        //            do {
        //                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        //            }
        //            catch {/* error handling here */
        //                UIAlertView(title: "fail write", message: "", delegate: nil, cancelButtonTitle: "OK").show()
        //            }
        //
        //            //reading
        //            do {
        //                _ = try String(contentsOf: path, encoding: String.Encoding.utf8)
        //            }
        //            catch {/* error handling here */
        //                UIAlertView(title: "fail read", message: "", delegate: nil, cancelButtonTitle: "OK").show()
        //            }
        //        }
        //
        //        if track1 == "" {
        //
        //            if track2.characters.count > 1 {
        //                if track2.contains(";") {
        //                    let reqData = track2.components(separatedBy: ";")[1]
        //                    if reqData.contains("=") {
        //                        finalData = reqData.components(separatedBy: "=")[0]
        //                    }
        //                }
        //            }
        //        } else {
        //
        //            if track2.characters.count > 1 {
        //                if track2.contains(";") {
        //                    let reqData = track2.components(separatedBy: ";")[1]
        //                    if reqData.contains("=") {
        //
        //                        let cardNo = reqData.components(separatedBy: "=")[0]
        //                        let expiryDateData = reqData.components(separatedBy: "=")[1]
        //
        //                        if expiryDateData.characters.count > 4 {
        //
        //                            let expiryYearMonth = String(expiryDateData.characters.prefix(4))
        //                            finalData = "\(cardNo)" + "=\(expiryYearMonth)"
        //                        }
        //                    }
        //                }
        //            }
        //        }
        
        var finalData = ""
        
        if track2.characters.count > 1 {
            if track2.contains(";") {
                let reqData = track2.components(separatedBy: ";")[1]
                if reqData.contains("=") {
                    
                    finalData = reqData.components(separatedBy: "=")[0]
                    
                    let expiryDateData = reqData.components(separatedBy: "=")[1]
                    
                    if expiryDateData.characters.count > 4 {
                        
                        let expiryYearMonth = String(expiryDateData.characters.prefix(4))
                        finalData = "\(finalData)" + "=\(expiryYearMonth)"
                    }
                }
            }
        }
        
        if finalData.characters.count > 5 {
            
            let index = finalData.index(finalData.startIndex, offsetBy: 5)
            let firstFiveDigit = finalData.substring(to: index)
            
            if firstFiveDigit == "30852" || firstFiveDigit == "20112" {
                //Loyalty Card Indentified
                finalData = finalData.components(separatedBy: "=")[0]
            }
            
            let viewController:BaseViewController? = self.viewControllers.last as? BaseViewController
            if viewController!.responds(to: #selector(BaseViewController.scannedBarcodeData)) {
                viewController!.scannedBarcodeData(finalData)
            }
        } else {
            let alert = UIAlertController(title: "Card swiped", message:"Invalid card", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectionState(_ state: Int32) {
        
        switch state {
            
        case 0://CONN_DISCONNECTED:
            print("DISCONNECTED")
        case 1://CONN_CONNECTING:
            print("CONNECTING")
        case 2://CONN_CONNECTED:
            print("CONNECTED")
        default:
            print("default")
        }
        
        let viewController:BaseViewController? = self.viewControllers.last as? BaseViewController
        if viewController!.responds(to: #selector(BaseViewController.connectionStatusUpdate)) {
            viewController!.connectionStatusUpdate(state)
        }
        
        //        UIAlertView(title: "connectionState", message: "\(state)", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func barcodeData(_ barcode: String!, type: Int32) {
        
        //        UIAlertView(title: "barcodeData", message: "\(barcode)" + "\(type)", delegate: nil, cancelButtonTitle: "OK").show()
        
        let viewController:BaseViewController? = self.viewControllers.last as? BaseViewController
        if viewController!.responds(to: #selector(BaseViewController.scannedBarcodeData)) {
            viewController!.scannedBarcodeData(barcode)
        }
    }
    
    // MARK: Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UINavigationController Methods
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let currentViewController = self.viewControllers.last
        if currentViewController!.isKind(of: BaseViewController.self) {
            let baseViewController: BaseViewController = currentViewController as! BaseViewController
            baseViewController.popingViewController()
        }
        
        return super.popViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        
        let currentViewController = self.viewControllers.last
        if currentViewController!.isKind(of: BaseViewController.self) {
            let baseViewController: BaseViewController = currentViewController as! BaseViewController
            baseViewController.popingViewController()
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        
        let currentViewController = self.viewControllers.last
        if currentViewController!.isKind(of: BaseViewController.self) {
            let baseViewController: BaseViewController = currentViewController as! BaseViewController
            baseViewController.popingViewController()
        }
        
        return super.popToRootViewController(animated: animated)
    }
}
