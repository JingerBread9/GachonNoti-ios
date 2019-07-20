//
//  myInfoPresenter.swift
//  GachonNoti
//
//  Created by USER on 20/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

protocol infoView: NSObjectProtocol {
    
    func show_hud()
    func dissmiss_hud()
    func reloadView()
    
}

class myInfoPresenter {
    
    private var userView : infoView?
    
    init(){
    }
    
    func attachView(_ view:infoView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func login(_ id:String ,_ pass:String){

        let parr = "{\"fsp_cmd\": \"login\",\"fsp_action\": \"UserAction\",\"DVIC_ID\": \"dwFraM1pVhl6mMn4npgL2dtZw7pZxw2lo2uqpm1yuMs=\",\"LOGIN_ID\": \"" + id + "\",\"USER_ID\": \"" + id + "\",\"PWD\": \"" + pass + "\",\"APPS_ID\": \"com.sz.Atwee.gachon\"}"
        
        userView?.show_hud()
        requestPost("http://smart.gachon.ac.kr:8080//WebJSON",parr,{result in
            //print(result)
            if (result.contains("\"eml\":")){
                //print("로그인성공")
                setData("id",id)
                setData("pass",pass)
                DispatchQueue.main.async {
                    self.userView?.reloadView()
                }
            }else{
                //print("로그인실패")
            }
            DispatchQueue.main.async {
                self.userView?.dissmiss_hud()
            }
        })
    }
    
}
