//
//  getRanColor.swift
//  GachonNoti
//
//  Created by USER on 10/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

func getRandomColorId() -> UIColor {
    let ran = arc4random_uniform(8)
    if (ran == 0){
        return hexStringToUIColor("#EF8676");
    }
    if (ran == 1){
        return hexStringToUIColor("#ECC269");
    }
    if (ran == 2){
        return hexStringToUIColor("#A7C96F");
    }
    if (ran == 3){
        return hexStringToUIColor("#79A5E8");
    }
    if (ran == 4){
        return hexStringToUIColor("#7CD0C1");
    }
    if (ran == 5){
        return hexStringToUIColor("#FBAA67");
    }
    if (ran == 6){
        return hexStringToUIColor("#9E86E1");
    }
    if (ran == 7){
        return hexStringToUIColor("#76CA88");
    }
    return hexStringToUIColor("#EF8676");
}

func hexStringToUIColor (_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
