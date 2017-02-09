//
//  GenericServiceManager.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 12/10/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol GenericServiceManagerDelegate {
    
    @objc optional func connectionDidFinishLoading(_ identifier: String, response: AnyObject)
    @objc optional func didFailedWithError(_ identifier: String, errorMessage: String)
}

class GenericServiceManager: NSObject, ConnectionManagerDelegate {
    
    var delegate: GenericServiceManagerDelegate?
    var identifier: String = ""
    
    // MARK: - Connection Delegates
    func connectionDidFinishLoading(_ response: NSDictionary) {
        if self.delegate?.connectionDidFinishLoading != nil {
            self.delegate!.connectionDidFinishLoading!(self.identifier, response: response)
        }
    }
    
    func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
