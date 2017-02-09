//
//  MultipleTicketsViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/20/15.
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


@objc protocol MultipleTicketsViewControllerDelegate {
    
    @objc optional func getTicketFromMultipleTickets(_ ticketBO: TicketBO)
    @objc optional func getVehicleDetails (_ vehicleDetails: VehicleDetailsBO)
    @objc optional func getFpCardFromMultipleCards(_ object: AnyObject, identifier: String)
    @objc optional func getMakeDetails(_ object: AnyObject)
    @objc optional func getModelDetails(_ object: AnyObject)
}

class MultipleTicketsViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate {
    
    var ticketsArray: [TicketBO]?
    var fpcardArray: [ReservationAndFPCardDetailsBO]?
    var reservationArray: [ReservationAndFPCardDetailsBO]?
    var fpCardWithReservationArray: [ReservationAndFPCardDetailsBO]?
    var vehicleMakeArray: [VehicleMakeBO]?
    var vehicleDetailsArray: [VehicleDetailsBO]?
    var delegate: MultipleTicketsViewControllerDelegate?
    var modelArray: NSArray = []
    var rowcount = Int()
    
    @IBOutlet weak var ticketTableView: UITableView!
    @IBOutlet weak var ticketOrFpNumber: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ticketTitleView: UIView!
    @IBOutlet weak var ticketTitleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbar1TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbar2TopConstraint: NSLayoutConstraint!
    
    //MARK: Viewcontroller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = ""
        
        if (fpcardArray  != nil){
            self.titleLabel.text = "Select FP Card"//Checkin - Look up - FP - 6699
            self.ticketOrFpNumber.text = "FP Card No"
        }else if (ticketsArray != nil){
            self.titleLabel.text = "Select Ticket"//Onlot - Lookup - Last name - mane
        }else if (reservationArray  != nil){
            self.titleLabel.text = "Select Reservation"//Not Found
            self.ticketOrFpNumber.text = "Reservation No"
        }else if (vehicleMakeArray != nil){
            self.titleLabel.text = "Select Make"//NA
            self.ticketTitleView.isHidden = true
            self.ticketTitleViewHeightConstraint.constant = 0
            self.nameLabel.isHidden = true
            self.ticketOrFpNumber.isHidden = true
        }else if (modelArray.count > 0 ){
            self.title = "Select Model"//Checkin - Vehicle - Model
            self.titleLabel.isHidden = true
            self.ticketTitleView.isHidden = true
            self.ticketTitleViewHeightConstraint.constant = 0
            self.toolbar1TopConstraint.constant = -44
            self.toolbar2TopConstraint.constant = -44
            self.nameLabel.isHidden = true
            self.ticketOrFpNumber.isHidden = true
        }else if (vehicleDetailsArray?.count > 0 ){
            self.titleLabel.text = "Select Vehicle"//Checkin - Look up - FP - 2152
            self.ticketOrFpNumber.text = "Vehicle Tag"
            self.nameLabel.text = "Make"
//            self.ticketTitleView.hidden = true
//            self.ticketTitleViewHeightConstraint.constant = 0
//            self.nameLabel.hidden = true
//            self.ticketOrFpNumber.hidden = true
        } else if (fpCardWithReservationArray?.count > 0) {
            self.titleLabel.text = "Select Reservation"//Checkin - Look up - FP - 3085280010000359142
            self.ticketOrFpNumber.text = "Reservation No"
        }
        ticketTableView.tableFooterView = UIView(frame:CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (fpcardArray  != nil){
            self.titleLabel.text = "Select FP card"
            self.ticketOrFpNumber.text = "FP Card No"
        }else if (ticketsArray != nil){
            self.titleLabel.text = "Select Ticket"
        }else if (reservationArray  != nil){
            self.titleLabel.text = "Select Reservation"
            self.ticketOrFpNumber.text = "Reservation No"
        }else if (vehicleMakeArray != nil){
            self.titleLabel.text = "Select Make"
            self.ticketTitleView.isHidden = true
            self.ticketTitleViewHeightConstraint.constant = 0
            self.nameLabel.isHidden = true
            self.ticketOrFpNumber.isHidden = true
        }else if (modelArray.count > 0 ){
            self.title = "Select Model"
            self.titleLabel.isHidden = true
            self.ticketTitleView.isHidden = true
            self.ticketTitleViewHeightConstraint.constant = 0
            self.toolbar1TopConstraint.constant = -44
            self.toolbar2TopConstraint.constant = -44
            self.nameLabel.isHidden = true
            self.ticketOrFpNumber.isHidden = true
        }else if (vehicleDetailsArray?.count > 0 ){
            self.titleLabel.text = "Select Vehicle"
            self.ticketOrFpNumber.text = "Vehicle Tag"
            self.nameLabel.text = "Make"
//            self.ticketTitleView.hidden = true
//            self.ticketTitleViewHeightConstraint.constant = 0
//            self.nameLabel.hidden = true
//            self.ticketOrFpNumber.hidden = true
        } else if (fpCardWithReservationArray?.count > 0) {
            self.titleLabel.text = "Select Reservation"//Checkin - Look up - FP - 3085280010000359142
            self.ticketOrFpNumber.text = "Reservation No"
        }
        ticketTableView.backgroundView = nil
        ticketTableView.backgroundColor = UIColor.clear
    }
    
    @IBAction func backButtonClicked(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (modelArray.count > 0 ) {
            return 100.0
        } else {
            return 49.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (fpcardArray != nil){
            rowcount = (fpcardArray?.count)!
        }else if (ticketsArray != nil){
            rowcount = (ticketsArray?.count)!
        }else if (reservationArray != nil){
            rowcount = (reservationArray?.count)!
        }else if (vehicleMakeArray != nil){
            rowcount = (vehicleMakeArray?.count)!
        }else if (modelArray.count > 0 ){
            rowcount = modelArray.count
        }else if (fpCardWithReservationArray != nil) {
            rowcount = (fpCardWithReservationArray?.count)!
        }else if (vehicleDetailsArray != nil) {
            rowcount = (vehicleDetailsArray?.count)!
        }
        return rowcount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MultipleTicketsTableViewCell
        if (fpcardArray != nil) {
            if let fpcardDetails = fpcardArray?[(indexPath as NSIndexPath).row] {
                cell.configureCellForFpCards(fpcardDetails)
            }
        }else if (ticketsArray != nil) {
            if let ticketDetails = ticketsArray?[(indexPath as NSIndexPath).row] {
                cell.configureCellForTickets(ticketDetails)
            }
        }else if (reservationArray != nil) {
            if let reservationDetails = reservationArray?[(indexPath as NSIndexPath).row] {
                cell.configureCellForReservations(reservationDetails)
            }
        }else if (vehicleMakeArray != nil) {
            if let makeDetails = vehicleMakeArray?[(indexPath as NSIndexPath).row] {
                cell.configureCellForVehiclemake(makeDetails)
            }
        }else if (modelArray.count > 0 ) {
            let modelCell = tableView.dequeueReusableCell(withIdentifier: "ModelCell") as! ModelTableViewCell
            modelCell.configureCellForVehicleModel(modelArray[(indexPath as NSIndexPath).row] as! String)
            return modelCell
            
        }else if (fpCardWithReservationArray != nil) {
            if let fpcardDetails = fpCardWithReservationArray?[(indexPath as NSIndexPath).row] {
                cell.configureCellForFpCardsWithReservations(fpcardDetails)
            }
        }else if (vehicleDetailsArray != nil) {
            if let vehicleDetails = vehicleDetailsArray?[(indexPath as NSIndexPath).row] {
                cell.configureCellForVehicleFP(vehicleDetails)
            }
        }
        cell.backgroundColor = UIColor.clear
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (fpcardArray != nil) {
            if let fpCardDetails = fpcardArray?[(indexPath as NSIndexPath).row]{
                //naviController?.popViewControllerAnimated(true)
                self.dismiss(animated: true, completion: nil)
                //                self.navigationController?.popViewControllerAnimated(true)
                self.delegate?.getFpCardFromMultipleCards!(fpCardDetails, identifier: "FPCard")
            }
        } else if (reservationArray != nil) {
            if let reservationsDetails = reservationArray?[(indexPath as NSIndexPath).row]{
                //naviController?.popViewControllerAnimated(true)
                self.dismiss(animated: true, completion: nil)
                //                self.navigationController?.popViewControllerAnimated(true)
                self.delegate?.getFpCardFromMultipleCards!(reservationsDetails, identifier: "Reservation")
            }
        } else if (fpCardWithReservationArray != nil) {
            if let fpCardDetails = fpCardWithReservationArray?[(indexPath as NSIndexPath).row]{
                //naviController?.popViewControllerAnimated(true)
                self.dismiss(animated: true, completion: nil)
                //                self.navigationController?.popViewControllerAnimated(true)
                self.delegate?.getFpCardFromMultipleCards!(fpCardDetails, identifier: "FPCardWithReservation")
            }
        } else if (ticketsArray != nil) {
            if let ticketDetails = ticketsArray?[(indexPath as NSIndexPath).row] {
                //naviController?.popViewControllerAnimated(true)
                self.dismiss(animated: true, completion: nil)
                //                self.navigationController?.popViewControllerAnimated(true)
                self.delegate!.getTicketFromMultipleTickets!(ticketDetails)
                
            }
        } else if (vehicleMakeArray != nil) {
            if let vehicleDetails = vehicleMakeArray?[(indexPath as NSIndexPath).row] {
                _ = naviController?.popViewController(animated: true)
                self.delegate?.getMakeDetails!(vehicleDetails)
                
            }
        } else if (modelArray.count > 0 ) {
            _ = naviController?.popViewController(animated: true)
            self.delegate?.getModelDetails!((modelArray[(indexPath as NSIndexPath).row] as? String)! as AnyObject)
            
        }else if (vehicleDetailsArray?.count > 0) {
            if let vehicleDetails = vehicleDetailsArray?[(indexPath as NSIndexPath).row] {
                self.dismiss(animated: true, completion: nil)
                self.delegate?.getVehicleDetails!(vehicleDetails)
            }
        }
    }
}
