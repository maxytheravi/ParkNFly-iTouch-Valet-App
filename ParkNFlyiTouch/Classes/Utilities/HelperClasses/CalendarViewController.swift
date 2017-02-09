//
//  CalendarViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/19/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

protocol CalendarDelegate {
    
    func getDateAndTime(_ date:String, time:String)
    func dismissCalendar()
}

class CalendarViewController: UIViewController, DSLCalendarViewDelegate {
    
    @IBOutlet weak var calendarView: DSLCalendarView!
    
    var delegate:CalendarDelegate?
    var visibleDate: Date?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.calendarView.delegate = self
        
        if let visibleDate = self.visibleDate {
            let components = ObjectiveCCommonMethods.setVisibleMonthForDSLCalendar(self.calendarView, with: visibleDate)
            self.calendarView.visibleMonth = components
            self.calendarView.selectedRange = DSLCalendarRange.init(startDay: components, endDay: components)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendarView(_ calendarView: DSLCalendarView, didSelect range: DSLCalendarRange) {
        
        let today: DateComponents = (Date() as NSDate).dslCalendarView_day(with: calendarView.visibleMonth.calendar)
        let startDate: DateComponents = range.startDay
        if self.day(startDate, isBeforeDay: today) {
            
            let alert = UIAlertController(title: klError, message:"Selected date must be greater than or equal to Today's date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: klOK, style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        self.delegate?.getDateAndTime(Utility.stringFromDate("yyyy-MM-dd", date: range.startDay.date!) as String, time:  Utility.stringFromDate("HH:mm:ss", date: range.startDay.date!) as String)
        
//        let date = self.stringFromDate("yyyy-MM-dd", date: range.startDay.date!)
//        let time = self.stringFromDate("HH:mm:ss", date: range.startDay.date!)
//        
//        self.delegate?.getDateAndTime(Utility.getUTCFromCurrentTimeZone(date, dateFormat: "yyyy-MM-dd"), time:  Utility.getUTCFromCurrentTimeZone(time, dateFormat: "HH:mm:ss"))
    }
    
//    func stringFromDate(formatter:String, date:NSDate) -> String {
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = formatter
//        
//        return dateFormatter.stringFromDate(date)
//    }

    func calendarView(_ calendarView: DSLCalendarView!) {
        self.delegate?.dismissCalendar()
    }
    
    func day(_ day1: DateComponents, isBeforeDay day2: DateComponents) -> Bool {
        return ((day1 as NSDateComponents).date)!.compare(((day2 as NSDateComponents).date)!) == ComparisonResult.orderedAscending
    }
}
