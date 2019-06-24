//
//  strFunc.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

extension String {
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString,
                                         options: NSString.CompareOptions.literal, range: nil)
    }
    
    func split2(w1:String,w2:String) -> String{
        return self.components(separatedBy: w1)[1].components(separatedBy: w2)[0]
    }
    
    
}
