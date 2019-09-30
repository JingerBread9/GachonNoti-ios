//
//  mainDetail.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import CurriculaTable
import DTZFloatingActionButton
import NVActivityIndicatorView
import Lottie

class timeTable: UIViewController , UIWebViewDelegate {
    
    @IBOutlet var loadT2: UILabel!
    @IBOutlet var loadT: UILabel!
    var starAnimationView = AnimationView()
    @IBOutlet weak var curriculaTable: CurriculaTable!
    let userPresenter = timeTablePresenter()
    
    override func viewWillAppear(_ animated: Bool) {
        starAnimationView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPresenter.attachView(self)
        tableinit()
    }
    
    func tableinit(){
        starAnimationView = AnimationView()
        let starAnimation = Animation.named("notfound")
        starAnimationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        starAnimationView.center.x = self.view.center.x
        starAnimationView.center.y = self.view.center.y - 60
        starAnimationView.contentMode = .scaleAspectFill
        starAnimationView.animation = starAnimation
        starAnimationView.loopMode = .loop
        view.addSubview(starAnimationView)

        curriculaTable.layer.cornerRadius = 10
        curriculaTable.layer.shadowColor = UIColor.gray.cgColor
        curriculaTable.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        curriculaTable.layer.shadowRadius = 5
        curriculaTable.layer.shadowOpacity = 0.7
        curriculaTable.isHidden = true
        
        loadT.numberOfLines = 0
        loadT.text = "오른쪽 하단 검색으로\n강의실 시간표를 불러오세요."
        loadT2.numberOfLines = 0
        loadT2.text = "(현재 시간에 맞춰 자동으로 \n해당 학기 시간표를 가져옵니다.)"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "데이터 리셋", style: .plain, target: self, action: #selector(del))
    }

    @objc func del(sender: UIBarButtonItem) {
        userPresenter.resetData()
    }

}

extension timeTable: timeTableView {

    func makeFAB(){
        let actionButton = DTZFloatingActionButton()
        actionButton.handler = {
            button in
            self.userPresenter.checkSearch()
        }
        actionButton.paddingY = 25
        actionButton.paddingX = 25
        actionButton.buttonImage = UIImage(named: "search")
        self.view.addSubview(actionButton)
    }
    
    func makeTable(arrTable:Array<CurriculaTableItem>?,max:Int){
        DispatchQueue.main.async {
            //print(arrTable!.description)
            self.curriculaTable.curricula = arrTable!
            ///curriculaTable.bgColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
            //self.curriculaTable.numberOfPeriods = 54
            //self.curriculaTable.borderWidth = 1
            //self.curriculaTable.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
            //self.curriculaTable.cornerRadius = 0
            //self.curriculaTable.textEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            self.curriculaTable.maximumNameLength = 20
            self.curriculaTable.isHidden = false
            self.starAnimationView.isHidden = true
            self.loadT.isHidden = true
            self.loadT2.isHidden = true
        }
    }
    
    func showAlert(viewController: UIViewController?,title: String, msg: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
        let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(defaultAction)
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        alertController.addAction(cancel)
        
        viewController?.present(alertController, animated: true, completion: nil)
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
    
    func justAlert(viewController: UIViewController?,title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(cancel)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func listAlert (arr:Array<String>,arr2:Array<String>,viewController: UIViewController?,title: String, msg: String){
        
        let alertController = UIAlertController(title: nil, message: "건물을 선택해주세요.", preferredStyle: .actionSheet)
        
        for i in arr{
            func someHandler(alert: UIAlertAction!) {
                var tmp = Array<String>()
                for i2 in arr2 {
                    if (i2.contains(i)){
                        tmp.append(i2)
                    }
                }
                self.listAlert2(arr: tmp, viewController: self)
            }
            let doo = UIAlertAction(title: i, style: .default, handler: someHandler)
            alertController.addAction(doo)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad { //디바이스 타입이 iPad일때
            if let popoverController = alertController.popoverPresentationController {
                // ActionSheet가 표현되는 위치를 저장해줍니다.
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                viewController?.present(alertController, animated: true, completion: nil)
            }
        } else {
            viewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func listAlert2 (arr:Array<String>,viewController: UIViewController?){
        let alertController = UIAlertController(title: nil, message: "강의실을 선택해주세요.", preferredStyle: .actionSheet)
        for i in arr{
            func someHandler(alert: UIAlertAction!) {
                self.userPresenter.showtable(str: i)
            }
            let doo = UIAlertAction(title: i, style: .default, handler: someHandler)
            alertController.addAction(doo)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad { //디바이스 타입이 iPad일때
            if let popoverController = alertController.popoverPresentationController {
                // ActionSheet가 표현되는 위치를 저장해줍니다.
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                viewController?.present(alertController, animated: true, completion: nil)
            }
        } else {
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setTitle(str:String){
        self.navigationItem.title = str
    }
    
}



