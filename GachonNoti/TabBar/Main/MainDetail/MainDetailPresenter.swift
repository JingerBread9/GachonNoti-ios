//
//  MainDetailPresenter.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//


import Foundation
import UIKit
import SwiftSoup

protocol MainDetailView: NSObjectProtocol {
    
    func show_web(js: String)
    func initTitle()
    
}

class MainDetailPresenter {
    
    private var userView: MainDetailView?
    
    init() {
    }
    
    func make_web(str: String) {
        userView?.show_web(js: str)
    }
    
    func attachView(_ view: MainDetailView, href: String) {
        userView = view
        request(href: href)
    }
    
    func detachView() {
        userView = nil
    }
    
    private func request(href: String) {
        //print(href)
        requestHTTP(url: href, completion: { result in
            //print(result)
            var boardView = ""
            do {
                let doc: Document = try SwiftSoup.parse(result)
                for div in try doc.select("div") {
                    if (div.hasClass("boardview")) {
                        for td in try div.select("td") {
                            if (td.hasClass("td")) {
                                let tmp = try td.html().description
                                if (tmp.contains("첨부")) {
                                    boardView = boardView + tmp + "<hr>"
                                }
                            }
                            if (td.hasClass("text")) {
                                let dTmp = try td.html().description
                                boardView = boardView + dTmp
                                //print(boardview)
                                if (boardView.contains("<script>document.location.href=\"")) {
                                    let href2 = boardView.split2(w1: "<script>document.location.href=\""
                                        , w2: "\";</script>")
                                    //print(href2)
                                    self.request(href: href2)
                                } else {
                                    boardView = boardView.replace("src=\"/",
                                                                  "src=\"http://www.gachon.ac.kr/")
                                    boardView = boardView.replace("href=\"/",
                                                                  "href=\"http://www.gachon.ac.kr/")
                                    DispatchQueue.main.async {
                                        self.userView?.show_web(js: boardView)
                                    }
                                }
                            }
                        }
                        break
                    }
                }
            } catch {
            }
        })
    }
}
