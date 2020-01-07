//
//  FindBuildingXML.swift
//  GachonNoti
//
//  Created by USER on 01/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

class FindTableXML: NSObject, XMLParserDelegate {
    
    var currentElement: String = ""
    var roomNM = ""
    var completion: (String, Array<Int>, Int) -> ()
    var done: (String) -> ()
    
    init(roomN: String, com: @escaping (String, Array<Int>, Int) -> (), dd: @escaping (String) -> ()) {
        roomNM = roomN
        completion = com
        done = dd
    }
    
    func start(_ data1: String, _ data2: String, _ data3: String) {
        realStart(data: data1)
        realStart(data: data2)
        realStart(data: data3)
        done("")
    }
    
    
    func realStart(data: String) {
        let data2 = data.replace("<?xml version='1.0' encoding='EUC-KR'?>", "")
        //print(data2)
        let parser = XMLParser(data: data2.data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        currentElement = elementName;
        if (currentElement == "grid") {
            room = ""
            time = ""
            subjectNm = ""
        }
        //print(currentElement)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //print(elementName)
        if (elementName == "grid") {
            //completion(tmp)
            if (room.contains(roomNM)) {
                subjectNm = subjectNm.replace("\n", "").replace(" ", "").replace("\t", "")
                room = room.replace("\n", "").replace(" ", "").replace("\t", "")
                time = time.replace("\n", "").replace(" ", "").replace("\t", "")
                //print(subjectNm)
                //print(room)
                //print(time)
                var roomCount = true
                var tmpRoom1 = room
                var tmpRoom2 = room
                if (room.contains(",")) {
                    tmpRoom1 = room.split1(w: ",", num: 0)
                    tmpRoom2 = room.split1(w: ",", num: 1)
                }
                
                let timeSplit = time.components(separatedBy: ",")
                var data = ["", "", "", "", "", "", ""]
                for tSplit in timeSplit {
                    if (tSplit.contains("월")) {
                        data[2] = data[2] + "," + tSplit
                    }
                    if (tSplit.contains("화")) {
                        data[3] = data[3] + "," + tSplit
                    }
                    if (tSplit.contains("수")) {
                        data[4] = data[4] + "," + tSplit
                    }
                    if (tSplit.contains("목")) {
                        data[5] = data[5] + "," + tSplit
                    }
                    if (tSplit.contains("금")) {
                        data[6] = data[6] + "," + tSplit
                    }
                }
                for i in 2...6 {
                    //print(data[i])
                    if (data[i].contains(",")) {
                        let sCom = data[i].components(separatedBy: ",")
                        
                        if ((roomCount && tmpRoom1.contains(roomNM)) ||
                            (!roomCount && tmpRoom2.contains(roomNM))) {
                            
                            let start = timeFormatChanger(table: sCom[1].replace(numToday(i), ""))[0]
                            let end = timeFormatChanger(table: sCom[sCom.count - 1].replace(numToday(i), ""))[1]
                            completion(subjectNm, [start, end], i)
                            
                        }
                        if (roomCount) {
                            roomCount = false
                        }
                        
                        
                    }
                }
                
            }
            
            
        }
    }
    
    var room = ""
    var time = ""
    var subjectNm = ""
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print(string)
        if (currentElement == "room") {
            room = room + string
        }
        if (currentElement == "time") {
            time = time + string
        }
        if (currentElement == "subjectNm") {
            subjectNm = subjectNm + string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
    func timeFormatChanger(table: String) -> Array<Int> {
        if (table == "A") {
            return [2, 7]
        }
        if (table == "B") {
            return [8, 13]
        }
        if (table == "C") {
            return [16, 21]
        }
        if (table == "D") {
            return [22, 27]
        }
        if (table == "E") {
            return [28, 33]
        }
        if (Int(table)! <= 8 && Int(table)! >= 1) {
            return [(Int(table)! - 1) * 4, Int(table)! * 4 - 1 - 1]
        }
        if (table == "9") {
            return [34, 37]
        }
        if (table == "10") {
            return [38, 41]
        }
        if (table == "11") {
            return [42, 44]
        }
        if (table == "12") {
            return [45, 49]
        }
        if (table == "13") {
            return [49, 51]
        }
        if (table == "14") {
            return [51, 54]
        } else {
            return [0, 0]
        }
    }
    
    func numToday(_ num: Int) -> String {
        if (num == 2) {
            return "월"
        }
        if (num == 3) {
            return "화"
        }
        if (num == 4) {
            return "수"
        }
        if (num == 5) {
            return "목"
        }
        if (num == 6) {
            return "금"
        }
        return ""
    }
    
}


