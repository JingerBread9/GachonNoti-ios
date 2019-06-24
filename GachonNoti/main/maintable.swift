//
//  main.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

class main_cell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var date: UILabel!
}

class maintable: UITableViewController{
    
    let userPresenter = maintablePresenter()
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPresenter.attachView(self)
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "main_cell", for: indexPath) as! main_cell
        cell.title.text = ""
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //userPresenter.set_chartsymbol(str: userPresenter.get_c_list()[indexPath.row][0])
        /*
        if (!userPresenter.get_c_list()[indexPath.row][1].contains("-")){
            let data_chart_ = self.storyboard?.instantiateViewController(withIdentifier: "data_tabbar") as! data_tabbar
            self.navigationController?.pushViewController(data_chart_, animated: true)
        }*/
    }
    
    
}

extension maintable: mainView {
    
   
    
}
