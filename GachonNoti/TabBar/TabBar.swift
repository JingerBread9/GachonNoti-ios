//
//  tabbar.swift
//  GachonNoti
//
//  Created by USER on 12/08/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import UIKit
import Foundation

var dark_theme = false

class TabBar: UITabBarController {
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 13.0, *) {
//            if self.traitCollection.userInterfaceStyle == .dark {
//                dark_theme = true
//            } else {
//                dark_theme = false
//            }
//        }else {
//            dark_theme = false
//        }
        
        if #available(iOS 13.0, *) {
            if(getDarkMode()){
                self.overrideUserInterfaceStyle = .dark
            }else{
                self.overrideUserInterfaceStyle = .light
            }
            dark_theme = getDarkMode();
        }
        
        let randNum = arc4random_uniform(10000).description
        requestHTTP(url: "http://wiffy.io/gachon/updateiOS/id_0124.txt?" + randNum, completion: { result in
            //print(result)
            if (result != "wowgachon") {
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
