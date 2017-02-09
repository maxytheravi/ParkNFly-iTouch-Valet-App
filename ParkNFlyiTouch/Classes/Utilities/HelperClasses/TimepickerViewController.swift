//
//  TimepickerViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/19/15.
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


protocol TimepickerDelegate {
    
    func getSelectedTime(_ time:String)
    func dismissTimePicker()
}

class TimepickerViewController: UIViewController {
    
    @IBOutlet weak var timepickerView: TimePickerView?
    var delegate:TimepickerDelegate?
    var selectedTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timepickerView = TimePickerView()
        timepickerView!.center = self.view.center
        if self.selectedTime != nil && self.selectedTime?.characters.count > 0 {
            timepickerView?.selectedTime = Utility.dateFromString(self.selectedTime!, dateFormat: "HH:mm:ss")
            timepickerView?.updatePredefinedTime()
        }
        
        self.view.addSubview(timepickerView!)
        unowned let weakself = self
        
        timepickerView?.onDoneTapped = {
            if weakself.delegate?.getSelectedTime != nil {
                weakself.delegate?.getSelectedTime(Utility.stringFromDate("HH:mm:ss", date: (weakself.timepickerView?.selectedTime)!) as String)
                
//                let time = self.stringFromDate("HH:mm:ss", date: (weakself.timepickerView?.selectedTime)!)
//                weakself.delegate?.getSelectedTime(Utility.getUTCFromCurrentTimeZone(time, dateFormat: "HH:mm:ss"))
            }
        }
        
        timepickerView?.onCancelTapped = {
            if weakself.delegate?.dismissTimePicker != nil {
                weakself.delegate?.dismissTimePicker()
            }
        }
    }
    
//    func stringFromDate(formatter:String, date:NSDate) -> String {
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = formatter
//        
//        return dateFormatter.stringFromDate(date)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
