//
//  DataSave.swift
//  GachonNoti
//
//  Created by USER on 20/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

func setData(_ name: String, _ value: String) {
    UserDefaults.standard.set(value, forKey: name)
}

func getData(_ name: String) -> String {
    let campus = UserDefaults.standard.value(forKey: name)
    if (campus == nil) {
        return ""
    } else {
        return campus as! String
    }
}
