//
//  getNoti.swift
//  GachonNoti
//
//  Created by USER on 10/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import Firebase

func getNotification() -> Bool {
    let isNotification = UserDefaults.standard.value(forKey: "isnoti")
    if (isNotification == nil) {
        return true
    } else {
        if (isNotification as! Int == 1) {
            return true
        } else {
            return false
        }
    }
}

func getNotificationStudentID() -> Bool {
    let isNotification = UserDefaults.standard.value(forKey: "isnotisid")
    if (isNotification == nil) {
        return false
    } else {
        if (isNotification as! Int == 1) {
            return true
        } else {
            return false
        }
    }
}

func notificationON() {
    Messaging.messaging().subscribe(toTopic: "noti") { error in
        UserDefaults.standard.set(1, forKey: "isnoti")
    }
}

func notificationOFF() {
    Messaging.messaging().unsubscribe(fromTopic: "noti") { error in
        UserDefaults.standard.set(0, forKey: "isnoti")
    }
}

func notificationStudentIDON() {
    if (!getNotificationStudentID()) {
        Messaging.messaging().subscribe(toTopic: getData("sid")) { error in
            UserDefaults.standard.set(1, forKey: "isnotisid")
        }
    }
}

func notificationStudentIDOFF() {
    Messaging.messaging().unsubscribe(fromTopic: getData("sid")) { error in
        UserDefaults.standard.set(0, forKey: "isnotisid")
    }
}
