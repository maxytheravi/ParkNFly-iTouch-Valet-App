//
//  NoteHistoryTableViewCell.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/18/16.
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


class NoteHistoryTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {

   
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func notesDetailPopOverButtonAction(_ sender: UIButton) {
        
        let mainStroyboard = Utility.createStoryBoardid(kMain)
        let customPopOverViewController = mainStroyboard.instantiateViewController(withIdentifier: "CustomPopOverViewController") as? CustomPopOverViewController
        
        customPopOverViewController!.modalPresentationStyle = UIModalPresentationStyle.popover
        customPopOverViewController!.preferredContentSize = CGSize(width: 500.0, height: 80.0)
        customPopOverViewController!.popoverPresentationController!.delegate = self
        
        customPopOverViewController!.popoverPresentationController!.sourceView = sender
        customPopOverViewController!.popoverPresentationController!.sourceRect = CGRect(x: 0, y: sender.frame.size.height/2.0, width: 0, height: 0)
        customPopOverViewController!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.right
        customPopOverViewController!.popoverPresentationController?.backgroundColor = UIColor.white
        if self.noteDescriptionLabel.text!.characters.count > 0 {
            customPopOverViewController!.descriptionText = self.noteDescriptionLabel.text
        }else {
            let alert = UIAlertController(title: klError, message:kNoteNotAvailable, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            naviController!.present(alert, animated: true, completion: nil)
        }
        
        naviController!.present(customPopOverViewController!, animated: true, completion: { _ in })
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func configureCellForNoteHistory(_ noteDetails: NotesHistoryBO) {
        self.noteDescriptionLabel.text = noteDetails.noteDescription
        self.nameLabel.text = noteDetails.cashierUserName
        if noteDetails.noteLogDate?.characters.count > 0 {
            self.dateLabel.text = Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(noteDetails.noteLogDate!), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyShortDateFormat())
            
        }else {
            self.dateLabel.text = ""
        }
        self.sectionLabel.text = noteDetails.section
    }

}
