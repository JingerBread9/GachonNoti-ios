//
//  getStatus.swift
//  GachonNoti
//
//  Created by USER on 10/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation


func getSemester() -> String {
    let today = NSDate()
    let monthFormatter = DateFormatter()
    monthFormatter.dateFormat = "M"
    let month = Int(monthFormatter.string(from: today as Date))!
    
    if (month >= 3 && month <= 6) {
        return "1"
    } else if (month >= 7 && month <= 8) {
        return "3"
    } else if (month >= 9 && month <= 12) {
        return "2"
    } else if (month >= 1 && month <= 2) {
        return "4"
    }
    
    return "0"
}

func getSemesterStr() -> String {
    let today = NSDate()
    let monthFormatter = DateFormatter()
    monthFormatter.dateFormat = "M"
    let month = Int(monthFormatter.string(from: today as Date))!
    
    if (month >= 3 && month <= 6) {
        return "1학기"
    } else if (month >= 7 && month <= 8) {
        return "여름학기"
    } else if (month >= 9 && month <= 12) {
        return "2학기"
    } else if (month >= 1 && month <= 2) {
        return "겨울학기"
    }
    
    return "---"
}

func getSemesterHttp() -> String {
    let today = NSDate()
    let monthFormatter = DateFormatter()
    monthFormatter.dateFormat = "M"
    let month = Int(monthFormatter.string(from: today as Date))!
    
    if (month >= 3 && month <= 6) {
        return "10"
    } else if (month >= 7 && month <= 8) {
        return "11"
    } else if (month >= 9 && month <= 12) {
        return "20"
    } else if (month >= 1 && month <= 2) {
        return "21"
    }
    
    return "0"
}

func getYear() -> String {
    let today = NSDate()
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    let year = yearFormatter.string(from: today as Date)
    return year
}

func getUserDefaults(_ key: String) -> String {
    let classData = UserDefaults.standard.value(forKey: key)
    if (classData == nil) {
        return "<no-data>"
    } else {
        if ((classData as! String).contains("<no-data>")) {
            return "<no-data>"
        } else {
            return classData as! String
        }
    }
}

