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
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "tab0")
            controller?.view.frame = mview.bounds
            mview.addSubview(controller!.view)
        }
        else if (num == 1){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "tab1")
            controller?.view.frame = mview.bounds
            mview.addSubview(controller!.view)
        }
        else if (num == 2){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "tab2")
            controller?.view.frame = mview.bounds
            mview.addSubview(controller!.view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tab0")
        controller?.view.frame = mview.bounds
        mview.addSubview(controller!.view)
    }
    
}
