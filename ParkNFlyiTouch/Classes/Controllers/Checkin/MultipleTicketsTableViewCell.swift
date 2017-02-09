//
//  MultipleTicketsTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/21/15.
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


class MultipleTicketsTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellForTickets(_ ticketDetails: TicketBO) {
        if ticketDetails.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberLabel.text = ticketDetails.prePrintedTicketNumber
        }else {
            self.ticketNumberLabel.text = ticketDetails.barcodeNumberString
        }
        self.nameLabel.text = ticketDetails.lastName
    }
    
    func configureCellForFpCards(_ fpCardDetails: ReservationAndFPCardDetailsBO) {
        self.ticketNumberLabel.text = fpCardDetails.fpCode
        self.nameLabel.text = fpCardDetails.lastName
    }
    
    func configureCellForFpCardsWithReservations(_ fpCardDetails: ReservationAndFPCardDetailsBO) {
        self.ticketNumberLabel.text = fpCardDetails.reservationCode
        self.nameLabel.text = fpCardDetails.lastName
    }
    
    func configureCellForReservations(_ reservationDetails: ReservationAndFPCardDetailsBO) {
        self.ticketNumberLabel.text = reservationDetails.reservationCode
        self.nameLabel.text = reservationDetails.lastName
    }
    
    func configureCellForVehiclemake(_ makeDetails: VehicleMakeBO) {
        self.ticketNumberLabel.text = makeDetails.vehicleMakeName as? String
        self.nameLabel.isHidden = true
    }
    
    func configureCellForVehicleModel(_ modelName: String) {
        self.ticketNumberLabel.text = modelName
        self.nameLabel.isHidden = true
    }
    
    func configureCellForVehicleFP(_ vehicleDetails:VehicleDetailsBO) {
        self.ticketNumberLabel.text = vehicleDetails.licenseNumber
        self.nameLabel.text = vehicleDetails.vehicleMake
    }
}
