//
//  SettingPresenter.swift
//  GachonNoti
//
//  Created by USER on 26/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

protocol SettingView: NSObjectProtocol {
    
    
}

class SettingPresenter {

    private var userView : SettingView?
    
    init(){
    }
    
    func attachView(_ view:SettingView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }

}



