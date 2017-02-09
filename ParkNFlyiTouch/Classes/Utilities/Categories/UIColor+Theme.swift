//
//  UIColor+Theme.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 01/02/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func projectThemeBlueColor() -> UIColor {
        return UIColor(red: 3.0/255.0, green: 39.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    }
    
//    func projectThemeGreenColor() -> UIColor {
//        return UIColor(red: 77.0/255.0, green: 169.0/255.0, blue: 106.0/255.0, alpha: 1.0)
//    }
    
    func projectThemeGreenColor() -> UIColor {
        return UIColor(red: 19.0/255.0, green: 172.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }
    
    func projectThemeRedColor() -> UIColor {
        return UIColor(red: 147.0/255.0, green: 12.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    }
    
    func projectThemeYellowColor() -> UIColor {
       return UIColor(red: 238.0/255.0, green: 164.0/255.0, blue: 50.0/255.0, alpha: 1.0)

    }
    
    func ticketNumberTextColor() -> UIColor {
        return UIColor(red: 147.0/255.0, green: 12.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    }
    
    func getSelectedColor(_ selectedColor: String) -> UIColor {
        var selectedColorRGB = UIColor()
        switch(selectedColor) {
            
        case "Marron":
            selectedColorRGB = UIColor(red: 162.0/255.0, green: 49.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            break
            
        case "Red":
            selectedColorRGB = UIColor(red: 255.0/255.0, green: 60.0/255.0, blue: 62.0/255.0, alpha: 1.0)
            break
            
        case "Blue":
            selectedColorRGB = UIColor(red: 61.0/255.0, green: 76.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            break
            
        case "Green":
            selectedColorRGB = UIColor(red: 70.0/255.0, green: 245.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            break
            
        case "Yellow":
            selectedColorRGB = UIColor(red: 255.0/255.0, green: 236.0/255.0, blue: 60.0/255.0, alpha: 1.0)
            break
            
        case "Orange":
            selectedColorRGB = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            break
            
        case "Purple":
            selectedColorRGB = UIColor(red: 228.0/255.0, green: 70.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            break
            
        case "Goldenrod":
            selectedColorRGB = UIColor(red: 232.0/255.0, green: 163.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            break
            
        case "DarkGray":
            selectedColorRGB = UIColor(red: 127.0/255.0, green: 127.0/255.0, blue: 127.0/255.0, alpha: 1.0)
            break
            
        case "Gray":
            selectedColorRGB = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
            break
            
        case "White":
            selectedColorRGB = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            break
            
        case "Black":
            selectedColorRGB = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            break
            
        default:
            selectedColorRGB = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            break
        }
        return selectedColorRGB
    }
    
}
