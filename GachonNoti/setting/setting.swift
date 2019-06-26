//
//  setting.swift
//  GachonNoti
//
//  Created by USER on 26/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog
import Firebase

class setting: UITableViewController{
    
    
    let userPresenter = settingPresenter()
    @IBOutlet var tableview: UITableView!
    @IBOutlet var noti_: UISwitch!
    
    @IBAction func noti(_ sender: Any) {
        if noti_.isOn{
            print("to on")
            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
            if isRegisteredForRemoteNotifications {
                Messaging.messaging().subscribe(toTopic: "noti") { error in
                    UserDefaults.standard.set(1, forKey: "isnoti")
                }
            } else {
                noti_.setOn(false, animated: false)
                UserDefaults.standard.set(0, forKey: "isnoti")
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            
        }else{
            print("to off")
            Messaging.messaging().unsubscribe(fromTopic: "noti") { error in
                UserDefaults.standard.set(0, forKey: "isnoti")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPresenter.attachView(self)
        let isnoti = UserDefaults.standard.value(forKey: "isnoti")
        if (isnoti == nil){
             noti_.setOn(true, animated: false)
        }else{
            if (isnoti as! Int == 1){
                noti_.setOn(true, animated: false)
            }else{
                noti_.setOn(false, animated: false)
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //후원
        if indexPath.section == 0 && indexPath.row == 1 {
            UIApplication.shared.openURL(NSURL(string: "http://wiffy.io/gachon/donation")! as URL)
        }
        //만든이
        if indexPath.section == 1 && indexPath.row == 0 {
            UIApplication.shared.openURL(NSURL(string: "https://github.com/wiffy-io")! as URL)
        }
        //오픈소스정보
        if indexPath.section == 1 && indexPath.row == 1 {
            let popup = PopupDialog(title: "오픈소스 정보", message:
                "https://github.com/scinfu/SwiftSoup\n" +
                "https://github.com/Orderella/PopupDialog\n" +
                "https://github.com/LeoMobileDeveloper/PullToRefreshKit\n" +
                "https://github.com/ninjaprox/NVActivityIndicatorView", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
        //도움을 주신 분들
        if indexPath.section == 1 && indexPath.row == 2 {
            requestHTTP(url: "http://wiffy.io/gachon/thanks.txt",completion: { result in
                //print(result)
                let rslt = result.replace(target: ",", withString: "\n")
                DispatchQueue.main.async {
                    let popup = PopupDialog(title: "후원 목록", message: rslt, image: nil)
                    self.present(popup, animated: true, completion: nil)
                }
            })
        }
        //버전
        if indexPath.section == 1 && indexPath.row == 3 {
            let popup = PopupDialog(title: "버전", message:
                "1.0.2(3)", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension setting: settingView {
    
}
