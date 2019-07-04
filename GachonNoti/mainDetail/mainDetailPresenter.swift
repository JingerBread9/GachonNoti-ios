//
//  mainDetailPresenter.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//


import Foundation
import UIKit
import SwiftSoup

protocol DetailView: NSObjectProtocol {

    func show_web(js:String)
    func initTitle()
    
}

class mainDetailPresenter{
    
    private var userView : DetailView?
    
    init(){
    }
    
    func make_web(str:String){
        userView?.show_web(js: str)
    }
    
    func attachView(_ view:DetailView,href:String){
        userView = view
        request(href: href)
    }
    
    func detachView() {
        userView = nil
    }
    
    private func request(href:String){
        //print(href)
        requestHTTP(url: href,completion: { result in
            //print(result)
            var boardview = ""
            do {
                let doc: Document = try SwiftSoup.parse(result)
                for div in try doc.select("div"){
                    if(div.hasClass("boardview")){
                        for td in try div.select("td"){
                            if(td.hasClass("td")){
                                let tmp = try td.html().description
                                if (tmp.contains("첨부")){
                                    boardview = boardview + tmp + "<hr>"
                                }
                            }
                            if(td.hasClass("text")){
                                let dtmp = try td.html().description
                                boardview = boardview + dtmp
                                //print(boardview)
                                if (boardview.contains("<script>document.location.href=\"")){
                                    let href2 = boardview.split2(w1: "<script>document.location.href=\""
                                        ,w2: "\";</script>")
                                    //print(href2)
                                    self.request(href: href2)
                                }else{
                                    boardview = boardview.replace("src=\"/",
                                                                  "src=\"http://www.gachon.ac.kr/")
                                    boardview = boardview.replace("href=\"/",
                                                                  "href=\"http://www.gachon.ac.kr/")
                                    DispatchQueue.main.async {
                                        self.userView?.show_web(js: boardview)
                                    }
                                }
                            }
                        }
                        break
                    }
                }
            } catch {}
        })
    }
}
