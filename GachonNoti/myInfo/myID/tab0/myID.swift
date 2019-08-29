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

let idPresenter = myIDPresenter()
class myID: UIViewController {
    
    @IBOutlet var timer: UILabel!
    
    @IBOutlet var logo: UIImageView!
    @IBOutlet var topView2: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var reNew_: UIButton!
    @IBOutlet var card: UIView!
    @IBOutlet var qrPic: UIImageView!
    @IBOutlet var userPic: UIImageView!
    @IBOutlet var dept: UILabel!
    @IBOutlet var sID: UILabel!
    @IBOutlet var name: UILabel!
    let userPresenter = idPresenter
    
    @IBAction func reNew(_ sender: Any) {
        userPresenter.getInfo2()
    }
    
    var mTimer : Timer?
    var number : Int = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logo.isHidden = true
        timer.isHidden = true
        
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        card.layer.shadowRadius = 3
        card.layer.shadowOpacity = 0.5
        
        reNew_.layer.cornerRadius = 5
        reNew_.layer.shadowColor = UIColor(red: 6/255, green: 68/255, blue: 138/255, alpha: 1).cgColor
        reNew_.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        reNew_.layer.shadowRadius = 5
        reNew_.layer.shadowOpacity = 0.7
        
        topView.roundCorners([.topLeft], radius: 10)
        topView2.roundCorners([.topRight], radius: 10)
        
        if (mTimer == nil){
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    
        userPresenter.attachView(self)
    }
    
    @objc func timerCallback(){
        if (number > 0){
            number -= 1
            let min = number / 60
            let sec = number % 60
            timer.text = min.description + " 분 " + sec.description + " 초"
        }
    }
    
}



extension myID: idView {
    
    func getInfo(_ name1:String, _ sID1:String, _ dept1:String, _ url:String){
        name.text = name1
        sID.text = sID1
        dept.text = dept1
        logo.isHidden = false
        timer.isHidden = false
        
        if (url.contains("http")){
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                userPic.image = image
                userPic.layer.masksToBounds = true
                userPic.layer.borderWidth = 1
                userPic.layer.borderColor = UIColor(red:220/255, green:220/255, blue:220/255, alpha: 1).cgColor
            }
        }

    }
    
    func getInfo2(_ url:String){
        if (url.contains("http")){
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                number = 300
                qrPic.image = image
            }
        }
    }
    
    func show_hud(){
        if (!NVActivityIndicatorPresenter.sharedInstance.isAnimating){
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    func dissmiss_hud(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
}

