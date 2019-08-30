//
//  tabMain.swift
//  GachonNoti
//
//  Created by USER on 29/08/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

class tabMain: UIViewController {
    @IBOutlet var tab_: UISegmentedControl!
    @IBOutlet var mview: UIView!
    
    @IBAction func tab(_ sender: Any) {
        for view in mview.subviews{
            view.removeFromSuperview()
        }
        let num = tab_.selectedSegmentIndex
        if (num == 0){
            add(asChildViewController: tab0)
        }
        else if (num == 1){
            add(asChildViewController: tab1)
        }
        else if (num == 2){
            add(asChildViewController: tab2)
        }
    }
    
    private lazy var tab0: myID = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "tab0") as! myID
        return viewController
    }()
    
    private lazy var tab1: tab1 = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "tab1") as! tab1
        return viewController
    }()
    
    private lazy var tab2: tab2 = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "tab2") as! tab2
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        //addChild(viewController)
        viewController.view.frame = mview.bounds
        mview.addSubview(viewController.view)
        //viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //viewController.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(asChildViewController: tab0)
    }

}
