//
//  myInfoPresenter.swift
//  GachonNoti
//
//  Created by USER on 20/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

protocol idView: NSObjectProtocol {
    
    func show_hud()
    func dissmiss_hud()
    func getInfo(_ name:String, _ sID:String, _ dept:String, _ url:String)
    func getInfo2(_ url:String)
}

class myIDPresenter {
    
    private var userView : idView?
    private var DEPT_NAME = ""
    private var KNAME = ""
    private var USER_NO = ""
    private var USER_IMG_PATH = ""
    private var qr = ""
    
    init(){
    }
    
    func attachView(_ view:idView){
        userView = view
        
        if (getData("id") != ""){
            getInfo()
        }
    }
    
    func detachView() {
        userView = nil
    }
    
    func getInfo(){
        let id = getData("id")
        
        if (getData("autoLogin") != "1"){
            setData("id","")
            setData("pass","")
        }
        
        let parr = "{\"USER_ID\":\"" + id + "\",\"fsp_ds_cmd\":[{\"TYPE\":\"N\",\"SQL_ID\":\"mobile/common:USER_INFO_SQL_S01\",\"INSERT_SQL_ID\":\"\",\"UPDATE_SQL_ID\":\"\",\"DELETE_SQL_ID\":\"\",\"SAVE_FLAG_COLUMN\":\"\",\"KEY_ZERO_LEN\":\"\",\"USE_INPUT\":\"N\",\"USE_ORDER\":\"Y\",\"EXEC\":\"\",\"FAIL\":\"\",\"FAIL_MSG\":\"\",\"EXEC_CNT\":0,\"MSG\":\"\"}],\"fsp_action\":\"xDefaultAction\",\"fsp_cmd\":\"execute\"}"
        
        userView?.show_hud()
        requestPost("http://smart.gachon.ac.kr:8080//WebJSON",parr,{ result in
            //print(result)
 
            self.DEPT_NAME = result.split2(w1: "\"DEPT_NAME\":\"", w2: "\"")
            self.KNAME = result.split2(w1: "\"KNAME\":\"", w2: "\"")
            self.USER_NO = result.split2(w1: "\"USER_NO\":\"", w2: "\"")
            self.USER_IMG_PATH = result.split2(w1: "\"USER_IMG_PATH\":\"", w2: "\"").replace("\\","")
            setData("sid", self.USER_NO)
            setData("sname", self.KNAME)
            setData("sdept", self.DEPT_NAME)
            
            DispatchQueue.main.async {
                self.userView?.getInfo(self.KNAME,self.USER_NO,self.DEPT_NAME,self.USER_IMG_PATH)
                self.getInfo2()
            }
        })

    }
    
    func getInfo2(){
        
        let parr = "{\"SQL_ID\":\"mobile/affairs:LIB_PS_ID_CARD_SQL_S01\",\"USER_NO\":\"m" + self.USER_NO + "\",\"fsp_action\":\"GcLibAction\",\"fsp_cmd\":\"executeMap\"}"
        
        requestPost("http://smart.gachon.ac.kr:8080//WebJSON",parr,{ result in
            self.qr = result.split2(w1: "\"qr\":\"", w2: "\"").replace("\\","")
            
            let time = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.userView?.getInfo2(self.qr)
                
                self.userView?.dissmiss_hud()
            }

        })
    }
    
}
