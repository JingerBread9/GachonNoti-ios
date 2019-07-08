//
//  mainDetailPresenter.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//


import Foundation
import UIKit
import CurriculaTable

protocol timeTableView: NSObjectProtocol  {
    
    func makeFAB()
    func makeTable(arrTable:Array<CurriculaTableItem>?,max:Int)
    func showAlert(viewController: UIViewController?,title: String, msg: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?)
    func show_hud()
    func dissmiss_hud()
    func justAlert(viewController: UIViewController?,title: String, msg: String)
    func listAlert (arr:Array<String>,arr2:Array<String>,viewController: UIViewController?,title: String, msg: String)
    func setTitle(str:String)
    
}

class timeTablePresenter {
  
    var ski = ""
    var classdata1 : Any?
    var classdata2 : Any?
    var classdata3 : Any?
    var build = Array<String>()
    var buildTotal = Array<String>()
    private var userView : timeTableView?
    private var getTablecnt = 0
    
    init(){
    }
    
    func attachView(_ view:timeTableView){
        userView = view
        initTitle()
        userView?.makeFAB()
//        userView?.makeTable(arrTable: nil)
    }
    
    func detachView() {
        userView = nil
    }
    
    func initTitle(){
        let today = NSDate()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "M"
        
        let year = yearFormatter.string(from: today as Date)
        let month = monthFormatter.string(from: today as Date)
        
        var semester = 1
        if (Int(month)! < 9){
            semester = 1
        }else{
            semester = 2
        }
        
        self.userView?.setTitle(str: year.description + "년 " + semester.description + "학기 - 빈 강의실 찾기")
    }
    
    func checkSearch(){
        let today = NSDate()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "M"
        
        let year = yearFormatter.string(from: today as Date)
        let month = monthFormatter.string(from: today as Date)
        
        var semester = 1
        if (Int(month) ?? 0 < 8){
            semester = 1
        }else{
            semester = 2
        }
        
        ski = year + "-" + semester.description
        classdata1 = UserDefaults.standard.value(forKey: ski + "-1")
        classdata2 = UserDefaults.standard.value(forKey: ski + "-2")
        classdata3 = UserDefaults.standard.value(forKey: ski + "-3")
        if (classdata1 == nil || classdata2 == nil || classdata3 == nil){
            toDownload(str:ski,y:year,seme:(semester * 10).description)
        }else{
            if ((classdata1 as! String).contains("<no-data>") ||
                (classdata2 as! String).contains("<no-data>") ||
                (classdata3 as! String).contains("<no-data>")){
                toDownload(str:ski,y:year,seme:(semester * 10).description)
            }else{
                self.userView?.show_hud()
                let queue = DispatchQueue(label: "work")
                queue.async{
                    self.build = Array<String>()
                    self.buildTotal = Array<String>()
                    findBuildingXML(com:{ n in
                        //print(n)
                        let nsplit = n.components(separatedBy: ",")
                        for aa in nsplit{
                            if (aa.contains("-")){
                                let tmpN = aa.split1(w: "-",num: 0)
                                if (!self.build.contains(tmpN)){
                                    self.build.append(tmpN)
                                }
                            }
                            if (!self.buildTotal.contains(aa)){
                                self.buildTotal.append(aa)
                            }
                        }
                    },dd: {_ in
                        self.buildTotal.sort()
                        self.build.sort()
                        //print(aa)
                        DispatchQueue.main.async {
                            self.userView?.dissmiss_hud()
                        }
                        self.userView?.listAlert(arr: self.build,arr2: self.buildTotal,viewController: self.userView as? UIViewController, title: self.ski, msg: "원하는 건물을 선택해주세요.")
                    }).start((self.classdata1 as! String) , (self.classdata2 as! String) , (self.classdata3 as! String))
                }
                
                
            }
        }
    }
    
    func showtable(str:String){
        //self.userView?.show_hud()
        var tablearr = Array<CurriculaTableItem>()
        var maxt = 0
        
        findTableXML(roomN:str,com:{ sub,time,day in
            //print(sub)//print(time[0].description)//print(time[1].description)
            if (maxt < time[1]){
                maxt = time[1]
            }
            let handler = { (curriculum: CurriculaTableItem) in}
            let infoSecA = CurriculaTableItem(name: sub, place: "", weekday: CurriculaTableWeekday(rawValue: day)!, startPeriod: time[0] + 1, endPeriod: time[1] + 1, textColor: UIColor.white, bgColor: self.getRandomColorId(), identifier: sub + time[0].description, tapHandler: handler)
            tablearr.append(infoSecA)
        },dd: {_ in
            DispatchQueue.main.async {
                //self.userView?.dissmiss_hud()
            }
            //print(tablearr)
            self.userView?.setTitle(str: "(" + self.ski + "학기) " + str)
            self.userView?.makeTable(arrTable: tablearr,max:maxt)
        }).start((self.classdata1 as! String) , (self.classdata2 as! String) , (self.classdata3 as! String))
        
        
    }
    
    func getRandomColorId() -> UIColor {
        let ran = arc4random_uniform(8)
        if (ran == 0){
            return hexStringToUIColor("#EF8676");
        }
        if (ran == 1){
            return hexStringToUIColor("#ECC269");
        }
        if (ran == 2){
            return hexStringToUIColor("#A7C96F");
        }
        if (ran == 3){
            return hexStringToUIColor("#79A5E8");
        }
        if (ran == 4){
            return hexStringToUIColor("#7CD0C1");
        }
        if (ran == 5){
            return hexStringToUIColor("#FBAA67");
        }
        if (ran == 6){
            return hexStringToUIColor("#9E86E1");
        }
        if (ran == 7){
            return hexStringToUIColor("#76CA88");
        }
        return hexStringToUIColor("#EF8676");
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toDownload(str:String,y:String,seme:String){
        func someHandler(alert: UIAlertAction!) {
            request("searchIsuCD=002",str + "-1",y,seme)
            request("searchIsuCD=001",str + "-2",y,seme)
            request("searchIsuCD=004",str + "-3",y,seme)
        }
        userView?.showAlert(viewController: userView! as? UIViewController, title: str + "학기\n시간표 데이터를 가져옵니다.", msg: "시간이 다소 걸릴 수 있으니 중간에 앱을 종료하지 마세요.\n(최초 한번만 다운로드 합니다.)", buttonTitle: "다운로드", handler: someHandler)
    }
    
    private func request(_ str:String,_ ski:String,_ y:String,_ seme:String){
        userView?.show_hud()
        let url = "http://gcis.gachon.ac.kr/haksa/src/jsp/ssu/ssu1000q.jsp?"
        let url2 = "groupType=20&searchYear=" + y + "&searchTerm=" + seme + "&" + str + "&operationType=MAINSEARCH&comType=DEPT_TOT_CD&comViewValue=N&comResultTarget=cbDeptCD&condition1=CS0000&condition2=20&condition3=TOT"
        requestHTTPEUC(url: url + url2,completion: { result in
            //print(result)
            UserDefaults.standard.set(result, forKey: ski)
            self.getTablecnt += 1
            if (self.getTablecnt >= 3){
                self.userView?.dissmiss_hud()
                if (result == "<no-data>"){
                     self.userView?.justAlert(viewController: self.userView as? UIViewController, title: "실패", msg: "데이터가 없습니다.")
                }else{
                    self.userView?.justAlert(viewController: self.userView as? UIViewController, title: "성공", msg: "다운로드가 완료되었습니다.")
                }
                
            }
        })
    }
    
    
    
    
}
