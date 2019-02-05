//
//  NetworkManager.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    var urlSession : URLSession
    
    private init () {
        let defaultConfiguration = URLSessionConfiguration.default
        self.urlSession = URLSession.init(configuration: defaultConfiguration)
    }
    
    func httpRequest(_ urlPath:String, params: [String: Any]?, method: String, onSuccess
        successBlock:@escaping ([String:Any])->Void, onFailure failureBlock:@escaping (Error)->Void) {
        
        let urlString = apiConstants.baseURL+urlPath
        
        guard let url = URL.init(string: urlString) else {
            return
        }
        var urlRequest = URLRequest.init(url:url,
                                         cachePolicy: .useProtocolCachePolicy,
                                         timeoutInterval:60.0)
        urlRequest.httpMethod = method
        if params != nil
        {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
        }
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (responseData, urlResponse, error) in
            
            if error == nil {
                
                if let urlResponse = urlResponse as? HTTPURLResponse {
                    
                    if urlResponse.statusCode == 200 {
                        if let responseData = responseData {
                            if let jsonObject = try? JSONSerialization.jsonObject(with: responseData,
                            options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                            {
                                successBlock(jsonObject!)
                            }
                        }
                    }
                    else {
                        let localizedErrorString = HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode)
                    }
                }
            }
            else {
                failureBlock(error!)
            }
        }
        dataTask.resume()
    }
    
    func getRequest(_ urlPath:String, params: [String: Any]?, onSuccess successBlock:@escaping ([String:Any])->Void, onFailure failureBlock:@escaping (Error)->Void) {
        
        self.httpRequest(urlPath, params: params, method: "GET", onSuccess: successBlock, onFailure: failureBlock)
    }
    
//    func getErrorObject(localizedString:String) -> Error {
//       // let error = Error()
//       // return error
//    }
}
