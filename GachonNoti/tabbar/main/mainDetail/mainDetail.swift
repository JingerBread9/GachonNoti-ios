//
//  mainDetail.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import WebKit

class mainDetail: UIViewController , UIWebViewDelegate {
    
    let userPresenter = mainDetailPresenter()
    
    var href:String?
    var titleS:String?
    var contentS:String?
    var dateS:String?
    
    @IBOutlet var web: UIWebView!
    @IBOutlet var contentt: UILabel!
    @IBOutlet var titlee: UILabel!
    @IBOutlet var datee: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitle()
        userPresenter.attachView(self,href: href!)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem : .action, target: self, action: #selector(move))
        web.delegate = self
    }
    
    @objc func move(sender: UIBarButtonItem) {
        UIApplication.shared.open(NSURL(string: href!)! as URL)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == .linkClicked {
            guard let url = request.url else { return true }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
}

extension mainDetail: DetailView {
    
    func show_web(js:String){
        self.web.loadHTMLString(js, baseURL: nil)
    }
    
    func initTitle(){
        self.navigationItem.title = titleS?.replace("[", "").replace("]", "")
        titlee.text = dateS
        contentt.text = contentS
        contentt.lineBreakMode = .byWordWrapping
        contentt.numberOfLines = 2;
        datee.text = ""
    }
    
}


