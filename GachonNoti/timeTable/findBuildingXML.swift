//
//  findBuildingXML.swift
//  GachonNoti
//
//  Created by USER on 01/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

class findBuildingXML: NSObject, XMLParserDelegate {
    
    var currentElement:String = ""

    var completion : (String)->()
    var done : (String)->()
    
    init(com: @escaping (String)->(), dd: @escaping (String)->()){
        completion = com
        done = dd
    }
    
    func start(_ data1:String,_ data2:String,_ data3:String){
        realStart(data: data1)
        realStart(data: data2)
        realStart(data: data3)
        done("")
    }

    
    func realStart(data:String){
        let data2 = data.replace("<?xml version='1.0' encoding='EUC-KR'?>", "")
        //print(data2)
        let parser = XMLParser(data: data2.data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if (currentElement == "grid") {
            //print("---")
            tmp = ""
        }
        //print(currentElement)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //print(elementName)
        
        if (elementName == "grid") {
            //tmp = utf8EncodedString(str:tmp)
            tmp = tmp.description.replace("\n", "").replace("\t", "")
            //tmp = tmp.replacingOccurrences(of: "@[0-9]{3,3}", with: "", options: .regularExpression, range: nil)
            if(tmp != ""){
                //print(tmp)
                completion(tmp)
            }
            
        }
    }
    
    
    var tmp = ""
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print(string)
        if (currentElement == "room") {
            tmp = tmp + string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
}


