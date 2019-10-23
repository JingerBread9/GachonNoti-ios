//
//  tab2.swift
//  GachonNoti
//
//  Created by USER on 29/08/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup
import PopupDialog

class CreditCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var max: UILabel!
    @IBOutlet var now: UILabel!
}

class Credit: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var sinfo: UILabel!
    private var data = [[String]]()
    @IBOutlet var mTableView: UITableView!
    @IBOutlet var card: UIView!

    override func viewWillAppear(_ animated: Bool) {
        self.data = [[String]]()
        getCredit()
        setInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.data = [[String]]()
        self.mTableView.reloadData()
        sinfo.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        card.layer.shadowRadius = 3
        card.layer.shadowOpacity = 0.5

        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.layer.masksToBounds = true
        mTableView.layer.cornerRadius = 10
        mTableView.layer.borderWidth = 1
        mTableView.layer.borderColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1).cgColor


    }

    func setInfo() {
        sinfo.text = getData("sdept") + "/" + getData("sname") + "/" + getData("sid")
    }

    func getCredit() {
        let url = "http://smart.gachon.ac.kr:8080/WebMain?STUDENT_NO=" + getData("sid") + "&SQL_ID=mobile%2Faffairs%3AAFFAIRS_CREDIT_INFO_SQL_S01&fsp_action=AffairsAction&fsp_cmd=executeMapList&callback_page=%2Fmobile%2Fgachon%2Faffairs%2FAffCreditInfoList.jsp"
        requestHTTP(url: url, completion: { result in
            do {
                let doc: Document = try SwiftSoup.parse(result)
                for tr in try doc.select("tr") {
                    var tmp = [String]()
                    for td in try tr.select("td") {
                        tmp.append(try td.text())
                    }
                    if (tmp.count >= 3) {
                        if (tmp[0] != "") {
                            //print(tmp.description)
                            self.data.append(tmp)
                        }
                    }
                }
                DispatchQueue.main.async {
                    //print(self.data)
                    self.mTableView.reloadData()
                }
            } catch {
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditCell2", for: indexPath) as! CreditCell
        cell.name.text = data[indexPath.row][0]
        cell.max.text = data[indexPath.row][1]
        cell.now.text = data[indexPath.row][2]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let popup = PopupDialog(title: data[indexPath.row][0], message:
        "이수기준: " + data[indexPath.row][1] + "\n" +
                "취득학점: " + data[indexPath.row][2], image: nil)
        self.present(popup, animated: true, completion: nil)
    }

}
