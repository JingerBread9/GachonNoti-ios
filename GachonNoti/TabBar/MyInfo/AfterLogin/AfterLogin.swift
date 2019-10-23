//
//  tabMain.swift
//  GachonNoti
//
//  Created by USER on 29/08/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

class TabMain: UIViewController {
    @IBOutlet var tab_: UISegmentedControl!
    @IBOutlet var mView: UIView!

    @IBAction func tab(_ sender: Any) {
        for view in mView.subviews {
            view.removeFromSuperview()
        }
        let num = tab_.selectedSegmentIndex
        if (num == 0) {
            add(asChildViewController: tab0)
        } else if (num == 1) {
            add(asChildViewController: tab1)
        } else if (num == 2) {
            add(asChildViewController: tab2)
        }
    }

    private lazy var tab0: IDCard = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "tab0") as! IDCard
        return viewController
    }()

    private lazy var tab1: Grade = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "tab1") as! Grade
        return viewController
    }()

    private lazy var tab2: Credit = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "tab2") as! Credit
        return viewController
    }()

    private func add(asChildViewController viewController: UIViewController) {
        //addChild(viewController)
        viewController.view.frame = mView.bounds
        mView.addSubview(viewController.view)
        //viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //viewController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        tab_.selectedSegmentIndex = 0
        for view in mView.subviews {
            view.removeFromSuperview()
        }
        add(asChildViewController: tab0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
