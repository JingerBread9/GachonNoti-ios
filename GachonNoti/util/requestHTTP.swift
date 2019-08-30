//
//  requestHTTP.swift
//  margin
//
//  Created by USER on 22/06/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation


func requestHTTP(url:String, completion: @escaping (String)->()){
    let url3 = URL(string: url)
    let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
        guard let data = data, error == nil else { return }
        let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        completion(result)
    }
    taskk2.resume()
}

func requestHTTPJson(url:String, json:Data, completion: @escaping (String)->()){
    let url2 = URL(string: url)!
    var request = URLRequest(url: url2)
    request.httpMethod = "POST"
    request.httpBody = json
    
    let taskk2 = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else { return }
        let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        completion(result)
    }
    taskk2.resume()
}

func requestHTTPEUC(url:String, completion: @escaping (String)->()){
    let url3 = URL(string: url)
    let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
        guard let data = data, error == nil else { return }
        //let result = NSString(data: data, encoding: String.Encoding.e)! as String
        guard let result = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(
            CFStringEncodings.EUC_KR.rawValue)))) else {
            completion("<no-data>")
            return
        }
        if (result.contains("haksuNo")){
            completion(result)
        }else{
            completion("<no-data>")
        }
        
    }
    taskk2.resume()
}

func requestPost(_ url:String, _ data:String, _ completion: @escaping (String)->()){
    let url = URL(string: url)!
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let parr = data
    request.httpBody = parr.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else { return }
        let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        completion(result)
    }
    
    task.resume()
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
