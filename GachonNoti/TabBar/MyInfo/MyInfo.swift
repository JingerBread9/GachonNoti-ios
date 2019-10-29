//
//  infoMain.swift
//  GachonNoti
//
//  Created by USER on 20/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

class InfoMain: UIViewController {
    
    @IBAction func changeCate(_ sender: Any) {
        checkToShow()
    }
    
    @objc func move(sender: UIBarButtonItem) {
        
        present(UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert).apply{ it in
            it.addAction(UIAlertAction(title: "확인", style: .destructive){ (action) in
                if (connectedToNetwork()) {
                    notificationStudentIDOFF()
                    setData("id", "")
                    setData("pass", "")
                    self.checkToShow()
                } else {
                    self.justAlert(title: "로그아웃 오류", msg: "인터넷 연결을 확인해주세요.")
                }
            })
            it.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        }, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkToShow()
    }
    
    func checkToShow() {
        if ((getData("id") == "") || (getData("pass") == "")) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(move))
            remove(asChildViewController: notLogin)
            add(asChildViewController: login)
        } else {
            notificationStudentIDON()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(move))
            remove(asChildViewController: login)
            add(asChildViewController: notLogin)
        }
        
        if(dark_theme){
            self.navigationController?.navigationBar.barTintColor = UIColor.black
        }
    }
    
    private lazy var login: MyInfo = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "myInfo") as! MyInfo
        return viewController
    }()
    
    private lazy var notLogin: TabMain = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "tabMain") as! TabMain
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 0)
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func justAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

