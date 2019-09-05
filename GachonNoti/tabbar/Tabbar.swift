//
//  tabbar.swift
//  GachonNoti
//
//  Created by USER on 12/08/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import UIKit
import Foundation

class tabbar: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randNum = arc4random_uniform(10000).description
        requestHTTP(url: "http://wiffy.io/gachon/updateiOS/id_1015.txt?" + randNum,completion: { result in
            //print(result)
            if (result != "wowgachon"){
                DispatchQueue.main.async {
                    self.viewControllers?.remove(at: 2)
                }
            }
        })
        
//        if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let
//            tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
//
//            tabBarItem.isEnabled = false
//            tabBarItem.title = "학생증(점검)"
//        }
    }
    

    
}
