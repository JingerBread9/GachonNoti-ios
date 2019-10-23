//
//  campusSet.swift
//  GachonNoti
//
//  Created by USER on 10/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

func setCampus(_ value: Int) {
    UserDefaults.standard.set(value, forKey: "campus")
}

func getCampus() -> Bool {
    let campus = UserDefaults.standard.value(forKey: "campus")
    if (campus == nil) {
        return true
    } else {
        if ((campus as! Int) == 1) {
            return true
        } else if ((campus as! Int) == 0) {
            return false
        } else {
            return true
        }
    }
}

func getCampusStr() -> String {
    let campus = UserDefaults.standard.value(forKey: "campus")
    if (campus == nil) {
        return "글로벌"
    } else {
        if ((campus as! Int) == 1) {
            return "글로벌"
        } else if ((campus as! Int) == 0) {
            return "메디컬"
        } else {
            return "글로벌"
        }
    }
}

func getCampusHttp() -> String {
    let campus = UserDefaults.standard.value(forKey: "campus")
    if (campus == nil) {
        return "20"
    } else {
        if ((campus as! Int) == 1) {
            return "20"
        } else if ((campus as! Int) == 0) {
            return "21"
        } else {
            return "20"
        }
    }
}
