//
//  NotesHistoryViewController.swift
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


class NotesHistoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ticketNumberTextField: TextField!
    @IBOutlet weak var noteDescriptionTextView: UITextView!
    
    @IBOutlet weak var titleSectionView: UIView!
    @IBOutlet weak var noteHistoryTableView: UITableView!
    
    var noteHistoryArray: [NotesHistoryBO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notes"
        
        self.noteHistoryTableView.allowsSelection = false
        self.noteDescriptionTextView.layer.cornerRadius = 5.0
        self.noteHistoryTableView.layer.borderWidth = 1.0
        self.noteHistoryTableView.layer.borderColor = UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        self.titleSectionView.layer.borderWidth = 1.0
        self.titleSectionView.layer.borderColor = UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).cgColor
        
        if naviController?.ticketBO?.prePrintedTicketNumber?.characters.count > 0 {
            self.ticketNumberTextField.text = naviController?.ticketBO?.prePrintedTicketNumber
        }else {
            self.ticketNumberTextField.text = naviController?.ticketBO?.barcodeNumberString
        }
        self.refreshView()
        
        //Keyboard Done Button
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NotesHistoryViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.noteDescriptionTextView.inputAccessoryView = numberToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.sharedInstance.showHUDWithLabel("Loading...")
        let allNotesHistoryServiceManager: GetAllTicketNotesService = GetAllTicketNotesService()
        allNotesHistoryServiceManager.delegate = self
        allNotesHistoryServiceManager.getAllTicketNotesWebService(kGetAllTicketNotes, parameters: ["TicketNumber":(naviController?.ticketBO?.barcodeNumberString)!])
    }
    
    func refreshView() {
        if self.noteHistoryArray?.count == 0 || self.noteHistoryArray?.count < 0 {
            self.titleSectionView.isHidden = true
            self.noteHistoryTableView.isHidden = true
        }else {
            self.titleSectionView.isHidden = false
            self.noteHistoryTableView.isHidden = false
            self.noteHistoryTableView.reloadData()
        }
    }
    
    func sortNotesArrayByDate() {
        
        for notesHistoryBO in self.noteHistoryArray! {
            notesHistoryBO.sortDate = Utility.dateFromString(Utility.stringFromDateStringWithoutT(Utility.getFormatedDateTimeWithT(notesHistoryBO.noteLogDate!)), dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        self.noteHistoryArray!.sort(by: { $0.sortDate!.compare($1.sortDate! as Date) == ComparisonResult.orderedDescending })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.noteHistoryArray?.count > 0 {
            return (self.noteHistoryArray?.count)!
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NoteHistoryTableViewCell
        if let noteHistoryDetails = self.noteHistoryArray?[(indexPath as NSIndexPath).row] {
            cell.configureCellForNoteHistory(noteHistoryDetails)
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: UITextView Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.noteDescriptionTextView.text = ""
        self.noteDescriptionTextView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text != "Add notes here" {
            self.noteDescriptionTextView.text = textView.text
        }else {
            self.noteDescriptionTextView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldString = textView.text ?? ""
        let startIndex = oldString.characters.index(oldString.startIndex, offsetBy: range.location)
        let endIndex = oldString.index(startIndex, offsetBy: range.length)
        let newString = oldString.replacingCharacters(in: startIndex ..< endIndex, with: text)
        return newString.characters.count <= 256
    }
    
    //MARK: UITextField method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        
        if self.noteDescriptionTextView.text == "Add notes here" {
            self.noteDescriptionTextView.text = ""
        }
        if self.noteDescriptionTextView.text.characters.count > 0 {
            Utility.sharedInstance.showHUDWithLabel("Loading...")
            let addNotesServiceManager: AddTicketNotesService = AddTicketNotesService()
            addNotesServiceManager.delegate = self
            addNotesServiceManager.addTicketNotesWebservice(kAddTicketNotes, parameters:["Note" : self.noteDescriptionTextView.text, "TicketNumber": (naviController?.ticketBO?.barcodeNumberString)!])
            ActivityLogsManager.sharedInstance.logUserActivity(("Ticket notes added by user :" + self.noteDescriptionTextView.text), logType: "Normal")

        }else {
            let alert = UIAlertController(title: klError, message: kNoteDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ identifier: NSString, response: AnyObject) {
        
        switch (identifier) {
            
        case kGetAllTicketNotes as String:
            
            self.noteHistoryArray = (response as? [NotesHistoryBO])!
            self.sortNotesArrayByDate()
            self.refreshView()
            
            break
            
        case kAddTicketNotes as String:
            let responseDict: NSDictionary = response as! NSDictionary
            let result = responseDict.getStringFromDictionary(withKeys: ["AddTicketNotesResponse","AddTicketNotesResult","a:Result"]) as String
            
            if result == "true" {
                let alert = UIAlertController(title: klSuccess, message: kSavedSuccessfully, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: klOK, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    _ = naviController?.popViewController(animated: true)
                })
                alert.addAction(okAction)
//                ActivityLogsManager.sharedInstance.logUserActivity(("Ticket note added successfully :" + self.noteDescriptionTextView.text), logType: "Normal")
                self.present(alert, animated: true, completion: nil)
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
    
    func didFailedWithError(_ identifier: NSString, errorMessage: String) {
        
        switch (identifier) {
            
        case kAddTicketNotes as String:
            
            let alert = UIAlertController(title: klError, message: (errorMessage as String), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
            
        default:
            break
        }
        Utility.sharedInstance.hideHUD()
    }
}
