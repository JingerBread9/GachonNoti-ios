//
//  ApplyUtil.swift
//  GachonNoti
//
//  Created by PaleCosmos on 2019/10/29.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

protocol HasApply{}

extension HasApply{
    func apply(closure:(Self) -> ()) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: HasApply { }

extension String{
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isBlank() -> Bool
    {
        return (self.trim() == "")
    }
    
    func isNotBlank() -> Bool
    {
        return !(self.trim() == "")
    }
}
