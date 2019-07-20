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
    }
    
}
