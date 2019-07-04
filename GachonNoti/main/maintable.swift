//
//  main.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
//import PullToRefreshKit
import NVActivityIndicatorView
import Firebase

class main_cell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet var new: UIImageView!
    @IBOutlet var save: UIImageView!
    @IBOutlet var newC: NSLayoutConstraint!
    @IBOutlet var saveC: NSLayoutConstraint!
}

class maintable: UITableViewController{
    
    let userPresenter = maintablePresenter()
    var refreshControll = UIRefreshControl()
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isnoti()
        userPresenter.attachView(self)
        
        refreshControll = UIRefreshControl()
        refreshControll.tintColor = UIColor.white
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControll
    }
    
    @objc func refresh(sender: UIBarButtonItem) {
        //self.refreshControll.beginRefreshing()
        self.userPresenter.reloadData()
    }

    func isnoti(){
        let isnoti = UserDefaults.standard.value(forKey: "isnoti")
        if (isnoti == nil){
            
        }else{
            if (isnoti as! Int == 1){
                Messaging.messaging().subscribe(toTopic: "noti") { error in
                    UserDefaults.standard.set(1, forKey: "isnoti")
                }
            }else{
                Messaging.messaging().unsubscribe(fromTopic: "noti") { error in
                    print("unSubscribed to noti topic")
                }
            }
        }
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.getData().count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "main_cell", for: indexPath) as! main_cell
        
        let data = userPresenter.getData()
        if (data.count > indexPath.row){
            cell.title.text = data[indexPath.row][0]
            
            if (data[indexPath.row][0].contains("메디컬")){
                cell.title.textColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 0.9)
            }else if (data[indexPath.row][0].contains("글로벌")){
                cell.title.textColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 0.9)
            }else{
                cell.title.textColor = UIColor(red: 47/255, green: 90/255, blue: 168/255, alpha: 1)
            }
            
            cell.content.text = data[indexPath.row][1]
            cell.date.text = data[indexPath.row][2]
            
            if (data[indexPath.row][4].contains("n")){
                cell.newC.constant = 35
            }else{
                cell.newC.constant = 0
            }
            
            if (data[indexPath.row][5].contains("n")){
                cell.saveC.constant = 20
            }else{
                cell.saveC.constant = 0
            }
            
            if (data[indexPath.row][6].contains("noti")){
                cell.backgroundColor = UIColor(red: 254/255, green: 246/255, blue: 227/255, alpha: 1)
            }else{
                cell.backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainDetail = self.storyboard?.instantiateViewController(withIdentifier: "mainDetail") as! mainDetail
        mainDetail.href = userPresenter.getData()[indexPath.row][3]
        mainDetail.titleS = userPresenter.getData()[indexPath.row][0]
        mainDetail.contentS = userPresenter.getData()[indexPath.row][1]
        mainDetail.dateS = userPresenter.getData()[indexPath.row][2]
        self.navigationController?.pushViewController(mainDetail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = userPresenter.getData().count - 1
        if (!userPresenter.isLoading() && indexPath.row == lastElement) {
            userPresenter.moreLoad()
        }
    }
    
   
}

extension maintable: mainView {
    
    func makeTable(get:[[String]]){
        //self.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
        self.refreshControll.endRefreshing()
        tableview.reloadData()
    }
    
    func show_hud(){
        if (!NVActivityIndicatorPresenter.sharedInstance.isAnimating){
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    func dissmiss_hud(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
}
