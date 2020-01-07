//
//  RequestHTTP.swift
//  margin
//
//  Created by USER on 22/06/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import SystemConfiguration

func requestHTTP(url: String, completion: @escaping (String) -> ()) {
    let mUrl = URL(string: url)
    let task = URLSession.shared.dataTask(with: mUrl! as URL) { data, response, error in
        guard let data = data, error == nil else {
            return
        }
        let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        completion(result)
    }
    task.resume()
}

func requestHTTPJson(url: String, json: Data, completion: @escaping (String) -> ()) {
    let mUrl = URL(string: url)!
    var request = URLRequest(url: mUrl)
    request.httpMethod = "POST"
    request.httpBody = json
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            return
        }
        let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        completion(result)
    }
    task.resume()
}

func requestHTTPEUC(url: String, completion: @escaping (String) -> ()) {
    let mUrl = URL(string: url)
    let task = URLSession.shared.dataTask(with: mUrl! as URL) { data, response, error in
        guard let data = data, error == nil else {
            return
        }
        //let result = NSString(data: data, encoding: String.Encoding.e)! as String
        guard let result = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(
            CFStringEncodings.EUC_KR.rawValue)))) else {
                completion("<no-data>")
                return
        }
        if (result.contains("haksuNo")) {
            completion(result)
        } else {
            completion("<no-data>")
        }
        
    }
    task.resume()
}

func requestPost(_ url: String, _ data: String, _ completion: @escaping (String) -> ()) {
    let url = URL(string: url)!
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let parr = data
    request.httpBody = parr.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            return
        }
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

func connectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    
    return (isReachable && !needsConnection)
}

