//
//  mainPresenter.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

protocol mainView: NSObjectProtocol {
    
    func makeTable(get:[[String]])
    func show_hud()
    func dissmiss_hud()
    
}

class maintablePresenter {
    
    private var data = [[String]]()
    private var userView : mainView?
    private var cnt = 0
    private var loading = false
    
    init(){
    }
    
    func attachView(_ view:mainView){
        userView = view
        findNoti(num: "0")
        //moreLoad()
    }
    
    func detachView() {
        userView = nil
    }
    
    func reloadData(){
        self.data = [[String]]()
        self.cnt = 0
        self.findNoti(num: "0")
    }
    
    func getData() -> [[String]]{
        return data
    }
    
    func isLoading() -> Bool {
        return loading
    }
    
    func moreLoad(){
        loading = true
        request(num: cnt.description)
        cnt += 1
    }
    
    private func request(num:String){
        userView?.show_hud()
        let url = "http://m.gachon.ac.kr/gachon/notice.jsp?pageNum=" + num + "&pageSize=20&boardType_seq=358"
        requestHTTP(url: url,completion: { result in
            do {
                let doc: Document = try SwiftSoup.parse(result)
                for div in try doc.select("div"){
                    if(div.hasClass("list")){
                        for li in try div.select("li"){
                            if (!li.description.contains("icon_notice.gif")){
                                self.parseList(li: li,cate : "content")
                            }
                        }
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.userView?.dissmiss_hud()
                    self.loading = false
                    self.userView?.makeTable(get: self.data)
                }
            } catch {}
        })
    }
    
    private func findNoti(num:String){
        userView?.show_hud()
        let url = "http://m.gachon.ac.kr/gachon/notice.jsp?pageNum=" + num + "&pageSize=10&boardType_seq=358"
        requestHTTP(url: url,completion: { result in
            do {
                let doc: Document = try SwiftSoup.parse(result)
                for div in try doc.select("div"){
                    if(div.hasClass("list")){
                        for li in try div.select("li"){
                            if (li.description.contains("icon_notice.gif")){
                                self.parseList(li: li,cate : "noti")
                            }
                        }
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.moreLoad()
                }
            } catch {}
        })
    }
    
    private func parseList(li:SwiftSoup.Element,cate:String){
        do{
            var href = try li.select("a").attr("href")
            let newSeq = href.split2(w1: "boardType_seq=",w2: "&")
            let newNo = href.split2(w1: "board_no=",w2: "&")
            href = "http://www.gachon.ac.kr/community/opencampus/06.jsp?" + "mode=view&boardType_seq=" + newSeq + "&board_no=" + newNo
            //print(href)
            var title = try li.select("a").select("strong").html()
            title = title.replace(" ", "")
            //print(title)
            var content = try li.select("a").html()
            content = content.description.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
            content = content.replace(title,  "")
            content = content.replace("  ",  "")
            //print(content)
            let date = try li.select("span").html()
            //print(date)
            var new = "n"
            var save = "n"
            if (!li.description.contains("icon_new.gif")){
                new = "y"
            }
            if (!li.description.contains("icon_file.gif")){
                save = "y"
            }
            self.data.append([title,content,date,href,new,save,cate])
        }catch {}
    }
}



