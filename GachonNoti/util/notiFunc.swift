//
//  getNoti.swift
//  GachonNoti
//
//  Created by USER on 10/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import Firebase

func getNoti() -> Bool{
    let isnoti = UserDefaults.standard.value(forKey: "isnoti")
    if (isnoti == nil){
        return true
    }else{
        if (isnoti as! Int == 1){
            return true
        }else{
            return false
        }
    }
}

func getNotiSid() -> Bool{
    let isnoti = UserDefaults.standard.value(forKey: "isnotisid")
    if (isnoti == nil){
        return false
    }else{
        if (isnoti as! Int == 1){
            return true
        }else{
            return false
        }
    }
}

func notiON(){
    Messaging.messaging().subscribe(toTopic: "noti") { error in
        UserDefaults.standard.set(1, forKey: "isnoti")
    }
}

func notiOFF(){
    Messaging.messaging().unsubscribe(fromTopic: "noti") { error in
        UserDefaults.standard.set(0, forKey: "isnoti")
    }
}

func notiSidON(){
    if (!getNotiSid()){
        Messaging.messaging().subscribe(toTopic: getData("sid")) { error in
            UserDefaults.standard.set(1, forKey: "isnotisid")
        }
    }
}

func notiSidOFF(){
    Messaging.messaging().unsubscribe(fromTopic: getData("sid")) { error in
        UserDefaults.standard.set(0, forKey: "isnotisid")
    }
}
