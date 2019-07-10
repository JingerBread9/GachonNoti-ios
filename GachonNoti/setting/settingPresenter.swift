//
//  settingPresenter.swift
//  GachonNoti
//
//  Created by USER on 26/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

protocol settingView: NSObjectProtocol {
    
    
}

class settingPresenter {

    private var userView : settingView?
    
    init(){
    }
    
    func attachView(_ view:settingView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    
    
}



