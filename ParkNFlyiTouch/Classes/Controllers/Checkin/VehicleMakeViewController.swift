//
//  VehicleMakeViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/2/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol VehicleMakeViewControllerDelegate {
    
    @objc optional func getVehicleMakeDetails(_ object: AnyObject)
}

class VehicleMakeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var vehicleMakeArray: [VehicleMakeBO]?
    var filtered:[String] = []
    var vehicleMakeNameArray = [String]()
    var delegate: VehicleMakeViewControllerDelegate?
    var searchActive : Bool = false
    var sections : [(index: Int, length :Int, title: String)] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Make"
        
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clear
        
        self.vehicleMakeArray = naviController?.vehicleMakeArray
        for vehicleBO in self.vehicleMakeArray! {
            let vehicleName = vehicleBO.vehicleMakeName as! String
            self.vehicleMakeNameArray.append(vehicleName)
        }
        
        var section = 0;
        var index = 0
        for make in self.vehicleMakeNameArray {

            let commonPrefix = make.commonPrefix(with: self.vehicleMakeNameArray[section], options: .caseInsensitive)
            if commonPrefix.characters.count == 0 {

                let string = self.vehicleMakeNameArray[section].uppercased();
                let firstCharacter = string[string.startIndex]
                let title = "\(firstCharacter)"
                let newSection = (index: section, length: index - section, title: title)
                self.sections.append(newSection)
                section = index;
            }

            index += 1
        }
        
//        var index = 0;
//        for ( var i = 0; i < self.vehicleMakeNameArray.count; i++ ) {
//            
//            let commonPrefix = self.vehicleMakeNameArray[i].commonPrefixWithString(self.vehicleMakeNameArray[index], options: .CaseInsensitiveSearch)
//            if commonPrefix.characters.count == 0 {
//                
//                let string = self.vehicleMakeNameArray[index].uppercaseString;
//                let firstCharacter = string[string.startIndex]
//                let title = "\(firstCharacter)"
//                let newSection = (index: index, length: i - index, title: title)
//                self.sections.append(newSection)
//                index = i;
//            }
//        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.searchActive) {
            return 1
        } else {
            return sections.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.searchActive) {
            return self.filtered.count
        }else {
            return sections[section].length
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        cell.textLabel?.textColor = UIColor.white
        if(self.searchActive){
            cell.textLabel?.text = self.filtered[(indexPath as NSIndexPath).row]
        }else {
            cell.textLabel?.text = self.vehicleMakeNameArray[sections[(indexPath as NSIndexPath).section].index + (indexPath as NSIndexPath).row]
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (searchActive) {
            if self.filtered[(indexPath as NSIndexPath).row].characters.count > 0  {
                _ = naviController?.popViewController(animated: true)
                self.delegate?.getVehicleMakeDetails!(self.filtered[(indexPath as NSIndexPath).row] as AnyObject)
            }
        } else {
            if (vehicleMakeArray != nil) {
                
                let sectionData = self.sections[(indexPath as NSIndexPath).section]
                
                if let vehicleDetails = vehicleMakeArray?[sectionData.index + (indexPath as NSIndexPath).row] {
                    let vehicleName = vehicleDetails.vehicleMakeName
                    _ = naviController?.popViewController(animated: true)
                    self.delegate?.getVehicleMakeDetails!(vehicleName!)
                }
            }
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map { $0.title }
    }
    
    //     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
    //
    //        return sections[section].title
    //
    //    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    //    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    //        searchActive = true;
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        searchActive = false;
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchActive = false;
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filtered = self.vehicleMakeNameArray.filter({ (text) -> Bool in
            if text.characters.count >= searchText.characters.count {
                let intialString = (text as NSString).substring(to: searchText.characters.count)
                if intialString.lowercased() == searchText.lowercased() {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        })
        
        if(searchText.characters.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
}
