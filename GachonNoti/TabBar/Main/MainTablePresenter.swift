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

protocol MainTableView: NSObjectProtocol {
    
    func makeTable(get: [[String]])
    func show_hud()
    func dismiss_hud()
    
}

class MainTablePresenter {
    
    private var data = [[String]]()
    private var userView: MainTableView?
    private var cnt = 0
    private var loading = false
    private var selectCateNum = "358"
    
    var notificationTitle = ""
    var notificationHref = ""
    var notificationDate = ""
    
    init() {
        getWiffyNoti()
    }
    
    func changeCateNum(_ num: String) {
        selectCateNum = num
    }
    
    func attachView(_ view: MainTableView) {
        userView = view
        findNotification(num: "0")
        //moreLoad()
    }
    
    func detachView() {
        userView = nil
    }
    
    func reloadData() {
        self.data = [[String]]()
        self.cnt = 0
        self.findNotification(num: "0")
    }
    
    func getData() -> [[String]] {
        return data
    }
    
    func isLoading() -> Bool {
        return loading
    }
    
    func moreLoad() {
        loading = true
        request(num: cnt.description)
        cnt += 1
    }
    
    private func getWiffyNoti(){
        let randNum = arc4random_uniform(10000).description
        requestHTTP(url: "http://wiffy.io/gachon/notification.txt?" + randNum, completion: { result in
            let content = result.components(separatedBy: ",")
            if(content[0] == "on"){
                self.notificationTitle = content[1]
                self.notificationDate = content[2]
                self.notificationHref = content[3]
            }
        })
    }
    
    private func request(num: String) {
        userView?.show_hud()
        let url = "http://m.gachon.ac.kr/gachon/notice.jsp?pageNum=" + num + "&pageSize=20&boardType_seq=" + selectCateNum
        requestHTTP(url: url, completion: { result in
            do {
                let doc: Document = try SwiftSoup.parse(result)
                for div in try doc.select("div") {
                    if (div.hasClass("list")) {
                        for li in try div.select("li") {
                            if (!li.description.contains("icon_notice.gif")) {
                                self.parseList(li: li, cate: "content")
                            }
                        }
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.userView?.dismiss_hud()
                    self.loading = false
                    
                    if(self.notificationTitle != "" && num == "0"){
                        self.data.insert(contentsOf: [["[가천알림이]", self.notificationTitle, self.notificationDate, self.notificationHref, "n", "y", "noti"]], at: 0)
                    }
                    self.userView?.makeTable(get: self.data)
                }
            } catch {
            }
        })
    }
    
    private func findNotification(num: String) {
        userView?.show_hud()
        let url = "http://m.gachon.ac.kr/gachon/notice.jsp?pageNum=" + num + "&pageSize=10&boardType_seq=" + selectCateNum
        requestHTTP(url: url, completion: { result in
            do {
                let doc: Document = try SwiftSoup.parse(result)
                for div in try doc.select("div") {
                    if (div.hasClass("list")) {
                        for li in try div.select("li") {
                            if (li.description.contains("icon_notice.gif")) {
                                self.parseList(li: li, cate: "noti")
                            }
                        }
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.moreLoad()
                }
            } catch {
            }
        })
    }
    
    private func parseList(li: SwiftSoup.Element, cate: String) {
        do {
            var href = try li.select("a").attr("href")
            let newSeq = href.split2(w1: "boardType_seq=", w2: "&")
            let newNo = href.split2(w1: "board_no=", w2: "&")
            if (newSeq == "") {
                throw NSError()
            }
            href = "http://www.gachon.ac.kr/community/opencampus/06.jsp?" + "mode=view&boardType_seq=" + newSeq + "&board_no=" + newNo
            //print(href)
            var title = try li.select("a").select("strong").html()
            title = title.replace(" ", "")
            if (title == "") {
                title = "[공통]"
            }
            //print(title)
            var content = try li.select("a").html()
            content = content.description.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
            content = content.replace(title, "")
            content = content.replace("  ", "")
            //print(content)
            let date = try li.select("span").html()
            //print(date)
            var new = "n"
            var save = "n"
            if (!li.description.contains("icon_new.gif")) {
                new = "y"
            }
            if (!li.description.contains("icon_file.gif")) {
                save = "y"
            }
            self.data.append([title, content, date, href, new, save, cate])
        } catch {
        }
    }
}



