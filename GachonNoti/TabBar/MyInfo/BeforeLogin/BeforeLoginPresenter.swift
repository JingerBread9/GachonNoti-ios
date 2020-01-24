//
//  myInfoPresenter.swift
//  GachonNoti
//
//  Created by USER on 20/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

protocol InfoView: NSObjectProtocol {
    
    func show_hud()
    func dismiss_hud()
    func reloadView()
    func justAlert(title: String, msg: String)
    
}

class myInfoPresenter {
    
    private var userView: InfoView?
    
    init() {
    }
    
    func attachView(_ view: InfoView) {
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func login(_ id: String, _ pass: String) {
        
        let parr = "{\"fsp_cmd\": \"login\",\"fsp_action\": \"UserAction\",\"DVIC_ID\": \"dwFraM1pVhl6mMn4npgL2dtZw7pZxw2lo2uqpm1yuMs=\",\"LOGIN_ID\": \"" + id + "\",\"USER_ID\": \"" + id + "\",\"PWD\": \"" + pass + "\",\"APPS_ID\": \"com.sz.Atwee.gachon\"}"
        
        userView?.show_hud()
        requestPost("http://smart.gachon.ac.kr:8080//WebJSON", parr, { result in
            //print(result)
            if (result.contains("\"eml\":")) {
                //print("로그인성공")
                do {
                    let key = (UIDevice().identifierForVendor?.uuidString ?? "vbiaewhfvewbfew").md5()
                    let iv = "gqLOHUioQ0QjhuvI"
                    let aesEn = try pass.aesEncrypt(key: key, iv: iv)
                    //let str3 = try str2.aesDecrypt(key: keyy, iv: ivv)
                    setData("id", id)
                    setData("pass", aesEn)
                } catch {
                }
                
                DispatchQueue.main.async {
                    self.userView?.reloadView()
                }
            } else {
                //print("로그인실패")
                DispatchQueue.main.async {
                    self.userView?.justAlert(title: "로그인 실패", msg: "다시한번 확인해주세요.")
                }
            }
            DispatchQueue.main.async {
                self.userView?.dismiss_hud()
            }
        })
    }
    
}
