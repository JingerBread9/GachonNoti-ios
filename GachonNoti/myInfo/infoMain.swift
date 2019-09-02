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
    
    @IBAction func changeCate(_ sender: Any) {
        checkToShow()
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
        setData("id","201611111")
        setData("pass","201611111")
        if ((getData("id") == "") || (getData("pass") == "")){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(move))
            remove(asChildViewController: notlogin)
            add(asChildViewController: login)
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(move))
            remove(asChildViewController: login)
            add(asChildViewController: notlogin)
        }
    }
    
    private lazy var login: myInfo = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "myInfo") as! myInfo
        return viewController
    }()
    
    private lazy var notlogin: tabMain = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "tabMain") as! tabMain
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabBarHeight)
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
}

