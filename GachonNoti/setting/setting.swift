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
            //UIApplication.shared.openURL(NSURL(string: "https://github.com/wiffy-io")! as URL)
            let popup = PopupDialog(title: "만든이", message:
                "박정호 - 소프트웨어학과\n(iveinvalue@gmail.com)\n\n" +
                "박상현 - 소프트웨어학과\n(okpsh0033@gmail.com)\n", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
//        pod 'CurriculaTable'
//        pod 'DTZFloatingActionButton'
//        pod 'lottie-ios'
        //오픈소스정보
        if indexPath.section == 1 && indexPath.row == 1 {
            let popup = PopupDialog(title: "오픈소스 정보", message:
                "SwiftSoup\nhttps://github.com/scinfu/SwiftSoup\n\n" +
                "CurriculaTable\nhttps://github.com/yzyzsun/CurriculaTable\n\n" +
                "DTZFloatingActionButton\nhttps://github.com/hintoz/DTZFloatingActionButton\n\n" +
                "Lottie-ios\nhttps://github.com/airbnb/lottie-ios\n\n" +
                "PopupDialog\nhttps://github.com/Orderella/PopupDialog\n\n" +
                "PullToRefreshKit\nhttps://github.com/LeoMobileDeveloper/PullToRefreshKit\n\n" +
                "NVActivityIndicatorView\nhttps://github.com/ninjaprox/NVActivityIndicatorView\n\n", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
        //도움을 주신 분들
        if indexPath.section == 1 && indexPath.row == 2 {
            let randNum = arc4random_uniform(10000)
            requestHTTP(url: "http://wiffy.io/gachon/thanks.txt?" + randNum.description,completion: { result in
                //print(result)
                let rslt = result.replace(",",  "\n") + "\n"
                DispatchQueue.main.async {
                    let popup = PopupDialog(title: "후원 목록", message: rslt, image: nil)
                    self.present(popup, animated: true, completion: nil)
                }
            })
        }
        //버전
        if indexPath.section == 1 && indexPath.row == 3 {
            let popup = PopupDialog(title: "버전", message:
                "1.0.5(6)\n", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension setting: settingView {
    
}
