//
//  SelectServiceForCategoryViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/27/15.
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


@objc protocol allSelectedServiceDelegate {
    @objc optional func getAllSelectedServiceDetail(_ selectedServiceArray:[ServiceBO])
}

class SelectServiceForCategoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ServiceForCategoryTableViewCellDelegate {
    
    var serviceArray:[ServiceBO] = []
    var delegate:allSelectedServiceDelegate?
        
    @IBOutlet weak var serviceDescriptionTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var viewMoveBy: CGFloat = 280
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select services"
        
        let doneButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SelectServiceForCategoryViewController.doneButtonAction))
        self.navigationItem.rightBarButtonItem = doneButton
        
        for serviceBO in self.serviceArray {
            if serviceBO.isServiceSelected == true && serviceBO.serviceNotes?.characters.count > 0 {
                self.serviceDescriptionTextView.text = serviceBO.serviceNotes
                break
            }
        }
        
        if self.serviceDescriptionTextView.text.characters.count == 0 {
            self.serviceDescriptionTextView.text = (serviceArray.first)?.serviceNotes
        }
        
        self.serviceDescriptionTextView.layer.borderWidth = 0.5
        self.serviceDescriptionTextView.layer.cornerRadius = 10.0
        self.serviceDescriptionTextView.layer.masksToBounds = true
        self.serviceDescriptionTextView.layer.borderColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0).cgColor
        
        //Keyboard Done Button
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectServiceForCategoryViewController.doneWithNumberPad))
        ]
        numberToolbar.sizeToFit()
        self.serviceDescriptionTextView.inputAccessoryView = numberToolbar
    }
    
    // MARK: NavigationBar button action
    func doneButtonAction() {
        //send all selected services to ServicesViewController
        _ = naviController?.popViewController(animated: true)
        if self.delegate?.getAllSelectedServiceDetail != nil {
            self.delegate?.getAllSelectedServiceDetail!(self.serviceArray)
        }
        
        self.view.endEditing(true)
    }
    
    //Keyboard Done Button
    func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: Delegate methods
    func selectService(_ serviceBo: ServiceBO) {
        
        if let _ = serviceBo.allowMultiple {
            if (serviceBo.allowMultiple)! == false {
                for service in self.serviceArray {
                    service.isServiceSelected = false
                }
            }
        }
        
        if (serviceBo.isServiceSelected == false) {
            serviceBo.isServiceSelected = true
            serviceBo.quantity = 1
        } else {
            serviceBo.isServiceSelected = false
            serviceBo.serviceNotes = ""
            serviceBo.isSwitchOn = true
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell") as! ServiceForCategoryTableViewCell
        let serviceBO:ServiceBO = self.serviceArray[(indexPath as NSIndexPath).row]
        cell.delegate = self
        cell.configureCell(serviceBO, forIndexPath: (indexPath as NSIndexPath).row)
        return cell
    }
    
    // MARK: - UITextView Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.bottomConstraint.constant = self.viewMoveBy
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        for serviceBO in serviceArray {
            serviceBO.serviceNotes = textView.text
            serviceBO.cashierUserName = (naviController?.authenticateUser)! + "\\" + (naviController?.userName)!
        }
        
        self.bottomConstraint.constant = 20.0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldString = textView.text ?? ""
        let startIndex = oldString.characters.index(oldString.startIndex, offsetBy: range.location)
        let endIndex = oldString.index(startIndex, offsetBy: range.length)
        let newString = oldString.replacingCharacters(in: startIndex ..< endIndex, with: text)
        return newString.characters.count <= 256
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            self.view.endEditing(true)
        }
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
