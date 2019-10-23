//
//  MainDetailPresenter.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//


import Foundation
import UIKit
import CurriculaTable

protocol TimeTableView: NSObjectProtocol {

    func makeFAB()
    func makeTable(arrTable: Array<CurriculaTableItem>?, max: Int)
    func showAlert(viewController: UIViewController?, title: String, msg: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?)
    func show_hud()
    func dismiss_hud()
    func justAlert(viewController: UIViewController?, title: String, msg: String)
    func listAlert(arr: Array<String>, arr2: Array<String>, viewController: UIViewController?, title: String, msg: String)
    func setTitle(str: String)

}

class timeTablePresenter {

    let year = getYear()
    let semester = getSemester()
    let semesterStr = getSemesterStr()
    var ski = ""

    var classData1: String?
    var classData2: String?
    var classData3: String?

    var build = Array<String>()
    var buildTotal = Array<String>()
    private var userView: TimeTableView?
    private var getTableCount = 0
    private var getTableCountError = 0

    init() {
    }

    func attachView(_ view: TimeTableView) {
        userView = view
        initTitle()
        userView?.makeFAB()
    }

    func detachView() {
        userView = nil
    }

    func initTitle() {
        self.userView?.setTitle(str: semesterStr)
    }

    func resetData() {
        ski = year + "-" + semester.description
        UserDefaults.standard.set("<no-data>", forKey: ski + "-1-" + getCampusHttp())
        UserDefaults.standard.set("<no-data>", forKey: ski + "-2-" + getCampusHttp())
        UserDefaults.standard.set("<no-data>", forKey: ski + "-3-" + getCampusHttp())
        self.userView?.justAlert(viewController: self.userView as? UIViewController, title: "성공", msg: "시간표 데이터를 리셋하였습니다.")
    }

    func checkSearch() {
        ski = year + "-" + semester.description
        classData1 = getUserDefaults(ski + "-1-" + getCampusHttp())
        classData2 = getUserDefaults(ski + "-2-" + getCampusHttp())
        classData3 = getUserDefaults(ski + "-3-" + getCampusHttp())

        if (classData1!.contains("<no-data>") &&
                classData2!.contains("<no-data>") &&
                classData3!.contains("<no-data>")) {
            toDownload(ski: ski)
        } else {
            self.userView?.show_hud()
            let queue = DispatchQueue(label: "work")
            queue.async {
                self.build = Array<String>()
                self.buildTotal = Array<String>()
                FindBuildingXML(com: { n in
                    //print(n)
                    let nSplit = n.components(separatedBy: ",")
                    for aa in nSplit {
                        if (aa.contains("-")) {
                            let tmpN = aa.split1(w: "-", num: 0)
                            if (!self.build.contains(tmpN)) {
                                self.build.append(tmpN)
                            }
                        }
                        if (!self.buildTotal.contains(aa)) {
                            self.buildTotal.append(aa)
                        }
                    }
                }, dd: { _ in
                    self.buildTotal.sort()
                    self.build.sort()
                    //print(aa)
                    DispatchQueue.main.async {
                        self.userView?.dismiss_hud()
                        self.userView?.listAlert(arr: self.build, arr2: self.buildTotal, viewController: self.userView as? UIViewController, title: self.ski, msg: "원하는 건물을 선택해주세요.")
                    }
                    //print(self.buildTotal)                    
                }).start(self.classData1!, self.classData2!, self.classData3!)
            }
        }
    }

    func showTable(str: String) {
        var tableArr = Array<CurriculaTableItem>()
        var maxT = 0

        FindTableXML(roomN: str, com: { sub, time, day in
            //print(sub)//print(time[0].description)//print(time[1].description)
            if (maxT < time[1]) {
                maxT = time[1]
            }
            let handler = { (curriculum: CurriculaTableItem) in
            }
            let infoSecA = CurriculaTableItem(name: sub, place: "", weekday: CurriculaTableWeekday(rawValue: day)!, startPeriod: time[0] + 1, endPeriod: time[1] + 1, textColor: UIColor.white, bgColor: getRandomColorId(), identifier: sub + time[0].description, tapHandler: handler)
            tableArr.append(infoSecA)
        }, dd: { _ in
            //print(tablearr)
            DispatchQueue.main.async {
                self.userView?.setTitle(str: str)
                self.userView?.makeTable(arrTable: tableArr, max: maxT)
            }
        }).start(self.classData1!, self.classData2!, self.classData3!)

    }

    func toDownload(ski: String) {
        func someHandler(alert: UIAlertAction!) {
            request("searchIsuCD=002", ski + "-1")
            request("searchIsuCD=001", ski + "-2")
            request("searchIsuCD=004", ski + "-3")
        }

        userView?.showAlert(viewController: userView! as? UIViewController, title: "[" + getCampusStr() + "] " + semesterStr + "\n시간표 데이터를 가져옵니다.", msg: "시간이 다소 걸릴 수 있으니 중간에 앱을 종료하지 마세요.\n(최초 한번만 다운로드 합니다.)", buttonTitle: "다운로드", handler: someHandler)
    }

    private func request(_ para: String, _ ski: String) {
        userView?.show_hud()
        let url = "http://gcis.gachon.ac.kr/haksa/src/jsp/ssu/ssu1000q.jsp?"
        let url2 = "groupType=" + getCampusHttp() + "&searchYear=" + getYear() + "&searchTerm=" + getSemesterHttp() + "&" + para + "&operationType=MAINSEARCH&comType=DEPT_TOT_CD&comViewValue=N&comResultTarget=cbDeptCD&condition1=CS0000&condition2=20&condition3=TOT"
        requestHTTPEUC(url: url + url2, completion: { result in
            let resultTMP = result.replace("(M)", "")
            UserDefaults.standard.set(resultTMP, forKey: ski + "-" + getCampusHttp())
            self.getTableCount += 1
            if (self.getTableCount >= 3) {
                self.userView?.dismiss_hud()
                //self.userView?.justAlert(viewController: self.userView as? UIViewController, title: "성공", msg: "다운로드가 완료되었습니다.")
                self.checkSearch()
            }
            if (result == "<no-data>") {
                self.getTableCountError += 1
            }
            if (self.getTableCountError >= 3) {
                self.userView?.justAlert(viewController: self.userView as? UIViewController, title: "실패", msg: "데이터가 없습니다.")
            }
        })
    }

}
