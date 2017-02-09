//
//  SelectionViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/26/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol SelectionDelegate {
    @objc optional func getSelectedServiceCategory(_ selectedServiceCategory:ServiceCategoryBO)
}

class SelectionViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate {
    
    var serviceCategoryArray:[ServiceCategoryBO] = []
    var delegate: SelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select service category"
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SerivceCategoryCell")
        let selectedServiceCategory:ServiceCategoryBO = serviceCategoryArray[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = selectedServiceCategory.serviceTypeName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = naviController?.popViewController(animated: true)
        let selectedServiceCategory:ServiceCategoryBO = serviceCategoryArray[(indexPath as NSIndexPath).row]
        self.delegate?.getSelectedServiceCategory!(selectedServiceCategory)
    }
}
