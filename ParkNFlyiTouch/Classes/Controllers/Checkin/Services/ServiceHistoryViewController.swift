//
//  ServiceHistoryViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/5/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ServiceHistoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var serviceHistoryCategoryDict = [String:Array<ServiceHistoryBO>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Service History"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return serviceHistoryCategoryDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dictKeys = [String](serviceHistoryCategoryDict.keys)
        let dateStr = dictKeys[section]
        return "  " + Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(dateStr), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyDateFormat())!
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let header: String = "customHeader"
//        var vHeader: UITableViewHeaderFooterView?
//        vHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier(header)!
//        if vHeader == nil {
//            vHeader = UITableViewHeaderFooterView(reuseIdentifier: header)
//            vHeader!.textLabel!.backgroundColor = UIColor.redColor()
//        }
//        
//        let dictKeys = [String](serviceHistoryCategoryDict.keys)
//        let dateStr = dictKeys[section]
//        vHeader!.textLabel!.text = "  " + Utility.dateStringFromString(Utility.stringFromDateStringWithoutT(dateStr), dateFormat: "yyyy-MM-dd HH:mm:ss", conversionDateFormat: Utility.getDisplyDateFormat())!
//        
//        return vHeader
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dateStr = [String](serviceHistoryCategoryDict.keys)[section]
        
        return (serviceHistoryCategoryDict[dateStr]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        let dateStr = [String](serviceHistoryCategoryDict.keys)[(indexPath as NSIndexPath).section]
        let serviceHistoryBO = serviceHistoryCategoryDict[dateStr]![(indexPath as NSIndexPath).row]
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        cell.textLabel?.text = serviceHistoryBO.category! + " - " + serviceHistoryBO.serviceName!
        
        return cell
    }
}
