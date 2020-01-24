//
//  Setting.swift
//  GachonNoti
//
//  Created by USER on 26/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog
import Firebase

class Setting: UITableViewController {
    
    let userPresenter = SettingPresenter()
    @IBOutlet var mTableView: UITableView!
    @IBOutlet var notificationSwitch: UISwitch!
    @IBOutlet var campus: UILabel!
    @IBOutlet var darkSwitch: UISwitch!
    @IBOutlet weak var darkView: UIView!
    
    @IBAction func darkSwitchListener(_ sender: Any) {
        showDarkPopupu()
        //        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    @IBAction func notificationSwitchListener(_ sender: Any) {
        if notificationSwitch.isOn {
            print("to on")
            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
            if isRegisteredForRemoteNotifications {
                notificationON()
            } else {
                notificationSwitch.setOn(false, animated: false)
                notificationOFF()
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                //UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
        } else {
            notificationOFF()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPresenter.attachView(self)
        
        notificationSwitch.setOn(getNotification(), animated: false)
        if #available(iOS 13.0, *) {
            darkSwitch.setOn(getDarkMode(), animated: false)
        }else{
            darkView.isHidden = true
        }
        
        if(dark_theme){
            self.navigationController?.navigationBar.barTintColor = UIColor.black
        }
        
        if (getCampus()) {
            campus.text = "[글로벌]"
        } else {
            campus.text = "[메디컬]"
        }
        
        
        //tableview.headerView(forSection: 2)?.detailTextLabel?.text = "상호 : 위피(WIFFY)\n사업자등록번호 : 572-16-01320\nⓒ WIFFY 2019"
    }
    
    
    // Section의 title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "기능"
        }
        if (section == 1) {
            return "정보"
        }
        if (section == 2) {
            return "상호 : 위피(WIFFY)\n사업자등록번호 : 572-16-01320\nⓒ WIFFY 2019"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //캠퍼스선택
        if indexPath.section == 0 && indexPath.row == 1 {
            showAlert()
        }
        
        //후원
        if indexPath.section == 0 && indexPath.row == 2 {
            UIApplication.shared.open(URL(string: "http://wiffy.io/gachon/donation")!)
            //UIApplication.shared.openURL(NSURL(string: "http://wiffy.io/gachon/donation")! as URL)
        }
        
        //버그
        if indexPath.section == 0 && indexPath.row == 3 {
            UIApplication.shared.open(URL(string: "https://open.kakao.com/o/gE49yGCb")!)
            //UIApplication.shared.openURL(NSURL(string: "https://open.kakao.com/o/gE49yGCb")! as URL)
            //            textAlert()
        }
        
        //만든이
        if indexPath.section == 1 && indexPath.row == 0 {
            //UIApplication.shared.openURL(NSURL(string: "https://github.com/wiffy-io")! as URL)
            let popup = PopupDialog(title: "만든이", message:
                "박정호 - 소프트웨어학과\n(iveinvalue@gmail.com)\n\n" +
                "박상현 - 소프트웨어학과\n(okpsh0033@gmail.com)\n", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
        
        //오픈소스정보
        if indexPath.section == 1 && indexPath.row == 1 {
            let popup = PopupDialog(title: "오픈소스 정보", message:
                "SwiftSoup\nhttps://github.com/scinfu/SwiftSoup\n\n" +
                    "CurriculaTable\nhttps://github.com/yzyzsun/CurriculaTable\n\n" +
                    "DTZFloatingActionButton\nhttps://github.com/hintoz/DTZFloatingActionButton\n\n" +
                    "Lottie-ios\nhttps://github.com/airbnb/lottie-ios\n\n" +
                    "PopupDialog\nhttps://github.com/Orderella/PopupDialog\n\n" +
                    "PullToRefreshKit\nhttps://github.com/LeoMobileDeveloper/PullToRefreshKit\n\n" +
                    "lottie-ios\nhttps://github.com/airbnb/lottie-ios\n\n" +
                    "TextFieldEffects\nhttps://github.com/raulriera/TextFieldEffects\n\n" +
                    "CryptoSwift\nhttps://github.com/krzyzanowskim/CryptoSwift\n\n" +
                "NVActivityIndicatorView\nhttps://github.com/ninjaprox/NVActivityIndicatorView\n", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
        
        //도움을 주신 분들
        if indexPath.section == 1 && indexPath.row == 2 {
            let randNum = arc4random_uniform(10000)
            requestHTTP(url: "http://wiffy.io/gachon/thanks.txt?" + randNum.description, completion: { result in
                //print(result)
                let rSlt = result.replace(",", "\n") + "\n"
                DispatchQueue.main.async {
                    let popup = PopupDialog(title: "후원 목록", message: rSlt, image: nil)
                    self.present(popup, animated: true, completion: nil)
                }
            })
        }
        
        //버전
        if indexPath.section == 1 && indexPath.row == 3 {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let popup = PopupDialog(title: "버전", message:
                appVersion + "\n", image: nil)
            self.present(popup, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "원하는 캠퍼스를 선택해주세요.", message: nil, preferredStyle: .alert)
        
        func globalHandler(alert: UIAlertAction!) {
            setCampus(1)
            campus.text = "[글로벌]"
        }
        
        let global = UIAlertAction(title: "글로벌", style: .default, handler: globalHandler)
        alertController.addAction(global)
        
        func medicalHandler(alert: UIAlertAction!) {
            setCampus(0)
            campus.text = "[메디컬]"
        }
        
        let medical = UIAlertAction(title: "메디컬", style: .default, handler: medicalHandler)
        alertController.addAction(medical)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textAlert() {
        let alert = UIAlertController(title: "버그리포트 / 개선사항", message: "버그나 개선하고자 하는 사항을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            //textField.text = "Some default text"
        }
        
        alert.addAction(UIAlertAction(title: "전송", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            var device = ""
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    device = "iPhone 5 or 5S or 5C"
                case 1334:
                    device = "iPhone 6/6S/7/8"
                case 2208:
                    device = "iPhone 6+/6S+/7+/8+"
                case 2436:
                    device = "iPhone X"
                default:
                    device = "unknown"
                }
            }
            
            let systemVersion = UIDevice.current.systemVersion
            let systemName = UIDevice.current.systemName
            let model = UIDevice.current.model
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            
            if (textField!.text!.count > 0) {
                self.goBug(textField!.text! + "/" + device + "/" + systemVersion + "/" + systemName + "/" + model + "/" + appVersion)
            }
        }))
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func goBug(_ str: String) {
        let url = "http://wiffy.io/gachon/reportios.php?content=" + str
        let str_url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        requestHTTP(url: str_url!, completion: { result in
            DispatchQueue.main.async {
                self.justAlert(title: "성공", msg: "전송이 완료되었습니다.")
            }
        })
    }
    
    func justAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showDarkPopupu() {
        let alertController = UIAlertController(title: "앱을 재시작하면 모드가 적용됩니다.", message: nil, preferredStyle: .alert)
        
        func globalHandler(alert: UIAlertAction!) {
            if darkSwitch.isOn {
                darModeON()
            }else{
                darkModeOFF()
            }
            exit(0)
        }
        
        let global = UIAlertAction(title: "확인", style: .default, handler: globalHandler)
        alertController.addAction(global)
        
        func medicalHandler(alert: UIAlertAction!) {
            darkSwitch.setOn(!darkSwitch.isOn, animated: false)
        }
        
        let medical = UIAlertAction(title: "취소", style: .default, handler: medicalHandler)
        alertController.addAction(medical)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Setting: SettingView {
    
}
