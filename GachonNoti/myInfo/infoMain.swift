//
//  infoMain.swift
//  GachonNoti
//
//  Created by USER on 20/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit


class infoMain: UIViewController {
    
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewStudentID: UIView!
    
    @IBAction func changeCate(_ sender: Any) {
        self.viewLogin.alpha = 0
        self.viewStudentID.alpha = 1
    }
    
    @objc func move(sender: UIBarButtonItem) {
        setData("id","")
        setData("pass","")
        checkToShow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkToShow()
    }
    
    func checkToShow(){
        if ((getData("id") == "") || (getData("pass") == "")){
            self.viewLogin.alpha = 1
            self.viewStudentID.alpha = 0
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(move))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(move))
            self.viewLogin.alpha = 0
            self.viewStudentID.alpha = 1
        }
    }
    
    func afterLogin(){
        
    }
}

