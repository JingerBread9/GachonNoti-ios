//
//  mainPresenter.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

protocol mainView: NSObjectProtocol {
    
    
}

class maintablePresenter {
    
    private var userView : mainView?
    
    init(){
    }
    
    func attachView(_ view:mainView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
}
