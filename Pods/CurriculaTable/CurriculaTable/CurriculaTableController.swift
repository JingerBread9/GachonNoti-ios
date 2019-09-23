//
//  CurriculaTableController.swift
//  CurriculaTable
//
//  Created by Sun Yaozhu on 2016-09-10.
//  Copyright © 2016 Sun Yaozhu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CurriculaTableController: UIViewController {
    
    weak var curriculaTable: CurriculaTable!
    
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(CurriculaTableCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
}

extension CurriculaTableController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (5 + 1) * curriculaTable.numberOfPeriods
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("========" + indexPath.row.description)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CurriculaTableCell
        cell.layer.sublayers?.removeAll()
        cell.backgroundColor = curriculaTable.symbolsBgColor
        //cell.textLabel.font = UIFont.systemFont(ofSize: curriculaTable.symbolsFontSize)
        //cell.layer.borderWidth = curriculaTable.borderWidth
        //cell.layer.borderColor = curriculaTable.borderColor.cgColor
    
        if indexPath.row == 0 {
            //cell.layer.addBorder([.top,.left], color: curriculaTable.borderColor, width: 1.0)
            //cell.textLabel.text = ""
        } else if indexPath.row < 6 {
            cell.layer.addText2(curriculaTable.weekdaySymbols[indexPath.row - 1])
            //cell.layer.addBorder([.left], color: curriculaTable.borderColor, width: 1.0)
            //cell.textLabel.text = curriculaTable.weekdaySymbols[indexPath.row - 1]
        } else if(indexPath.row % 6 == 0 && indexPath.row / 6 % 4 == 1){
            let hour = indexPath.row / 6 / 4 + 9
            cell.layer.addText(hour.description)
            cell.layer.addBorder([.top], color: curriculaTable.borderColor, width: 1.0)
            //cell.textLabel.text = hour.description
        }else {
            cell.backgroundColor = UIColor.clear
            if(indexPath.row / 6 % 4 == 1){
                cell.layer.addBorder([.top], color: curriculaTable.borderColor, width: 1.0)
            }else{
                if(indexPath.row % 6 == 0){
                    //cell.layer.addBorder([.left], color: curriculaTable.borderColor, width: 1.0)
                }else{
                    //cell.layer.addBorder([.left], color: curriculaTable.borderColor, width: 1.0)
                }
                
            }
            //cell.textLabel.text = ""
        }
        if(indexPath.row % 6 == 5){
            //cell.layer.addBorder([.right], color: curriculaTable.borderColor, width: 1.0)
        }
        return cell
    }
    
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
    func addText(_ text: String) {
        let myTextLayer = CATextLayer()
        myTextLayer.string = text
        myTextLayer.fontSize = 11
        myTextLayer.contentsScale = UIScreen.main.scale
        myTextLayer.alignmentMode = .center
        myTextLayer.contentsGravity = .center
        //myTextLayer.backgroundColor = UIColor.white.cgColor
        myTextLayer.foregroundColor = UIColor.black.cgColor
        //myTextLayer.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
        myTextLayer.frame = self.bounds
        self.addSublayer(myTextLayer)
    }
    
    func addText2(_ text: String) {
        let myTextLayer = CATextLayer()
        myTextLayer.string = text
        myTextLayer.fontSize = 15
        myTextLayer.contentsScale = UIScreen.main.scale
        myTextLayer.alignmentMode = .center
        myTextLayer.contentsGravity = CALayerContentsGravity.center
        //myTextLayer.backgroundColor = UIColor.white.cgColor
        myTextLayer.foregroundColor = UIColor.black.cgColor
        myTextLayer.frame = CGRect(x:0, y:4, width:self.bounds.width, height:self.bounds.height)
        //myTextLayer.frame = self.bounds
        self.addSublayer(myTextLayer)
    }
    
}


extension CurriculaTableController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: curriculaTable.widthOfPeriodSymbols, height: curriculaTable.heightOfWeekdaySymbols)
        } else if indexPath.row < 6 {
            return CGSize(width: curriculaTable.averageWidth, height: curriculaTable.heightOfWeekdaySymbols)
        } else if indexPath.row % 6 == 0 {
            return CGSize(width: curriculaTable.widthOfPeriodSymbols, height: curriculaTable.averageHeight)
        } else {
            return CGSize(width: curriculaTable.averageWidth, height: curriculaTable.averageHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
