//
//  myInfo.swift
//  GachonNoti
//
//  Created by USER on 19/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import NVActivityIndicatorView

class myInfo: UIViewController  {
    
    let userPresenter = myInfoPresenter()
    
    @IBOutlet var grayView2: UIView!
    @IBOutlet var grayView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var idForm_: HoshiTextField!
    @IBOutlet var passForm_: HoshiTextField!
    @IBOutlet var loginForm_: UIButton!
    
    @IBOutlet var autoLogin_: UISwitch!
    @IBAction func autoLogin(_ sender: Any) {
        
        if (autoLogin_.isOn){
            setData("autoLogin","1")
        }else{
            setData("autoLogin","0")
        }
        
    }
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        userPresenter.login(idForm_.text!,passForm_.text!)
    }
    @IBOutlet var login: UIButton!
    @IBAction func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (getData("autoLogin") != "0"){
            autoLogin_.setOn(true, animated: true)
            setData("autoLogin","1")
        }else{
            autoLogin_.setOn(false, animated: true)
            setData("autoLogin","0")
        }
        
        setUI()
        userPresenter.attachView(self)
    }
    
    func setUI(){
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = #colorLiteral(red: 0.231372549, green: 0.4784313725, blue: 0.8235294118, alpha: 1)
        
        idForm_.inputAccessoryView = toolBarKeyboard
        passForm_.inputAccessoryView = toolBarKeyboard
        
        loginForm_.layer.cornerRadius = 10
        loginForm_.layer.shadowColor = UIColor(red: 58/255, green: 122/255, blue: 210/255, alpha: 1).cgColor
        loginForm_.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        loginForm_.layer.shadowRadius = 5
        loginForm_.layer.shadowOpacity = 0.7
        
        loginView.layer.cornerRadius = 10
        loginView.layer.shadowColor = UIColor.gray.cgColor
        loginView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        loginView.layer.shadowRadius = 3
        loginView.layer.shadowOpacity = 0.5
        
        grayView.roundCorners([.topLeft], radius: 10)
        grayView2.roundCorners([.topRight], radius: 10)
        
    }
    
  
    
}



extension myInfo: infoView{
    
    func show_hud(){
        if (!NVActivityIndicatorPresenter.sharedInstance.isAnimating){
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    func dissmiss_hud(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func reloadView(){
        if let parent = self.parent as? infoMain {
            parent.checkToShow()
        }
        idPresenter.getInfo()
    }
    
    func justAlert(title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
