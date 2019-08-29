//
//  tab1.swift
//  GachonNoti
//
//  Created by USER on 29/08/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

class tab1: UIViewController {
    
    @IBOutlet var card: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        card.layer.shadowRadius = 3
        card.layer.shadowOpacity = 0.5

    }
    
}
