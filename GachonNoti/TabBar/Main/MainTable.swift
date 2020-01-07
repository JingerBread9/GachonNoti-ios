//
//  main.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Firebase

class MainTableCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet var new: UIImageView!
    @IBOutlet var save: UIImageView!
    @IBOutlet var newC: NSLayoutConstraint!
    @IBOutlet var saveC: NSLayoutConstraint!
}

class MainTable: UITableViewController, UISearchBarDelegate{
    
    @IBOutlet var viewTab: UIView!
    @IBOutlet var viewSearch: UIView!
    let userPresenter = MainTablePresenter()
    var mRefreshControl = UIRefreshControl()
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet var selectCate_: UISegmentedControl!
    
    @IBAction func selectCate(_ sender: Any) {
        let num = selectCate_.selectedSegmentIndex
        if (num == 0) {
            userPresenter.changeCateNum("358")
        }
        if (num == 1) {
            userPresenter.changeCateNum("359")
        }
        if (num == 2) {
            userPresenter.changeCateNum("360")
        }
        if (num == 3) {
            userPresenter.changeCateNum("361")
        }
        self.userPresenter.reloadData()
    }
    
    @IBOutlet var search_: UISearchBar!
    
    @IBAction func doneBtnClicked(sender: Any) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchStr_ = search_.text!
        let searchStr = searchStr_.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let num = selectCate_.selectedSegmentIndex
        if (num == 0) {
            userPresenter.changeCateNum("358&searchopt=title&searchword=" + searchStr)
        }
        if (num == 1) {
            userPresenter.changeCateNum("359&searchopt=title&searchword=" + searchStr)
        }
        if (num == 2) {
            userPresenter.changeCateNum("360&searchopt=title&searchword=" + searchStr)
        }
        if (num == 3) {
            userPresenter.changeCateNum("361&searchopt=title&searchword=" + searchStr)
        }
        self.userPresenter.reloadData()
        search_.showsCancelButton = false
        search_.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPresenter.attachView(self)
        showUpdateStr()

        mRefreshControl = UIRefreshControl()
        mRefreshControl.tintColor = UIColor.white
        mRefreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = mRefreshControl
        
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = #colorLiteral(red: 0.231372549, green: 0.4784313725, blue: 0.8235294118, alpha: 1)
        
        search_.inputAccessoryView = toolBarKeyboard
        search_.delegate = self
        
        if(dark_theme){
            self.navigationController?.navigationBar.barTintColor = UIColor.black
            self.view.backgroundColor = UIColor.black
            search_.barTintColor = UIColor.black
            selectCate_.backgroundColor = UIColor.black
            viewTab.backgroundColor = UIColor.black
            viewSearch.backgroundColor = UIColor.black
        }else{
            search_.layer.borderWidth = 1
            search_.layer.borderColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        }
    }
    
    func showUpdateStr() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let isNotification = UserDefaults.standard.value(forKey: appVersion)
        if (isNotification == nil) {
            UserDefaults.standard.set("aa", forKey: appVersion)
            justAlert(viewController: self, title: "업데이트 내용", msg: "iOS13 대응 및 버그 수정")
        }
    }
    
    func justAlert(viewController: UIViewController?, title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(cancel)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    @objc func refresh(sender: UIBarButtonItem) {
        self.mRefreshControl.endRefreshing()
        let num = selectCate_.selectedSegmentIndex
        if (num == 0) {
            userPresenter.changeCateNum("358")
        }
        if (num == 1) {
            userPresenter.changeCateNum("359")
        }
        if (num == 2) {
            userPresenter.changeCateNum("360")
        }
        if (num == 3) {
            userPresenter.changeCateNum("361")
        }
        self.userPresenter.reloadData()
    }
    
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.getData().count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTableView.dequeueReusableCell(withIdentifier: "main_cell", for: indexPath) as! MainTableCell
        
        let data = userPresenter.getData()
        if (data.count > indexPath.row) {
            cell.title.text = data[indexPath.row][0]
            
            if (data[indexPath.row][0].contains("메디컬")) {
                cell.title.textColor = UIColor(red: 70 / 255, green: 170 / 255, blue: 70 / 255, alpha: 0.9)
            } else if (data[indexPath.row][0].contains("글로벌")) {
                cell.title.textColor = UIColor(red: 200 / 255, green: 70 / 255, blue: 70 / 255, alpha: 0.9)
            } else {
                cell.title.textColor = UIColor(red: 47 / 255, green: 90 / 255, blue: 168 / 255, alpha: 1)
            }
            
            cell.content.text = data[indexPath.row][1]
            cell.date.text = data[indexPath.row][2]
            
            if (data[indexPath.row][4].contains("n")) {
                cell.newC.constant = 35
            } else {
                cell.newC.constant = 0
            }
            
            if (data[indexPath.row][5].contains("n")) {
                cell.saveC.constant = 20
            } else {
                cell.saveC.constant = 0
            }
            if (data[indexPath.row][6].contains("noti")){
                if(dark_theme){
                    cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.15)
                    cell.date.textColor = UIColor.white
                }else{
                    cell.backgroundColor = UIColor(red: 254/255, green: 246/255, blue: 227/255, alpha: 1)
                    cell.content.textColor = UIColor.black
                    cell.date.textColor = UIColor.black
                }
                
            }else{
                if(dark_theme){
                    cell.backgroundColor = UIColor.black
                    cell.content.textColor = UIColor.white
                    cell.date.textColor = UIColor.white
                }else{
                    cell.backgroundColor = UIColor.white
                    cell.content.textColor = UIColor.black
                    cell.date.textColor = UIColor.black
                }
            }
        }
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainDetail = self.storyboard?.instantiateViewController(withIdentifier: "mainDetail") as! MainDetail
        mainDetail.href = userPresenter.getData()[indexPath.row][3]
        mainDetail.titleS = userPresenter.getData()[indexPath.row][0]
        mainDetail.contentS = userPresenter.getData()[indexPath.row][1]
        mainDetail.dateS = userPresenter.getData()[indexPath.row][2]
        self.navigationController?.pushViewController(mainDetail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = userPresenter.getData().count - 1
        if (!userPresenter.isLoading() && indexPath.row == lastElement) {
            if (userPresenter.getData().count > 10) {
                userPresenter.moreLoad()
            }
            
        }
    }
    
    
}

extension MainTable: MainTableView {
    
    func makeTable(get: [[String]]) {
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        self.mTableView.reloadData()
    }
    
    func show_hud() {
        if (!NVActivityIndicatorPresenter.sharedInstance.isAnimating) {
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    func dismiss_hud() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
}

