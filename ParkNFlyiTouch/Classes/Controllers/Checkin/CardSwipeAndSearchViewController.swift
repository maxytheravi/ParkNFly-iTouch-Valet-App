//
//  CardSwipeAndSearchViewController.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/5/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class CardSwipeAndSearchViewController: BaseViewController {

    /** UITextField outlet for reservation number textField.
     */
    @IBOutlet weak var reservationNumberTextfield: TextField!
    /** UITextField outlet for fpcard number textField.
     */
    @IBOutlet weak var fpcardTextfield: TextField!
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
