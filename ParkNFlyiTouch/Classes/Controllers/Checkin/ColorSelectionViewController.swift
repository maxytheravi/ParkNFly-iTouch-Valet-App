//
//  ColorSelectionViewController.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/29/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol ColorSelectionViewControllerDelegate {
   @objc optional func getSelectedColor(_ selectedColor: Int)
}

class ColorSelectionViewController: BaseViewController {
    
    @IBOutlet weak var colorSelectionView: UIView!
    var delegate:ColorSelectionViewControllerDelegate?
    @IBOutlet var colorButtons : [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorSelectionView.layer.borderWidth = 2.0
        self.colorSelectionView.layer.cornerRadius = 0
        self.colorSelectionView.layer.masksToBounds = true
        self.colorSelectionView.layer.borderColor = UIColor(red: 9.0/255.0, green: 54.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor
        
        naviController?.view.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        self.colorSelectionView.isUserInteractionEnabled = true
        for button in colorButtons {
            button.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.superview!.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        self.colorSelectionView.isUserInteractionEnabled = true
        for button in colorButtons {
            button.isUserInteractionEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorSelectionButtonAction(_ sender: UIButton) {
        
        _ = naviController?.popViewController(animated: true)
        
//        var colors: Colors = Colors.kMaroon
//        
//        switch sender.tag {
//        case 1: colors = Colors.kMaroon
//        case 2: colors = Colors.kRed
//        case 3: colors = Colors.kBlue
//        case 4: colors = Colors.kGreen
//        case 5: colors = Colors.kYellow
//        case 6: colors = Colors.kOrange
//        case 7: colors = Colors.kPurple
//        case 8: colors = Colors.kGoldenrod
//        case 9: colors = Colors.kDarkGray
//        case 10: colors = Colors.kGray
//        case 11: colors = Colors.kWhite
//        case 12: colors = Colors.kBlack
//        default: break
//        }
        
        self.delegate?.getSelectedColor!(sender.tag)
    }
    
    @IBAction func closeButtonAction(_ sender: AnyObject) {
        _ = naviController?.popViewController(animated: true)
    }
}
