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