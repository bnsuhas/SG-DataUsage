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
    
    private init () {
        //Change default initialiser to private to make sure no other instance of Network MAnager are created.
    }
    
    func httpRequest(_ urlPath:String, params: [String: Any]?, method: String, onSuccess
        successBlock:@escaping ([String:Any])->Void, onFailure failureBlock:@escaping (NSError)->Void) {
        
        let urlString = apiConstants.baseURL+urlPath
        
        let defaultConfiguration = URLSessionConfiguration.default
        let urlSession = URLSession.init(configuration: defaultConfiguration)
        
        guard let url = URL.init(string: urlString) else {
            return
        }
        var urlRequest = URLRequest.init(url:url,
                                         cachePolicy: .useProtocolCachePolicy,
                                         timeoutInterval:60.0)
        urlRequest.httpMethod = method
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (responseData, urlResponse, error) in
            
        }
        dataTask.resume()
    }
    
    func getRequest(_ urlPath:String, params: [String: Any]?, onSuccess successBlock:@escaping ([String:Any])->Void, onFailure failureBlock:@escaping (NSError)->Void) {
        
        self.httpRequest(urlPath, params: params, method: "GET", onSuccess: successBlock, onFailure: failureBlock)
    }
}
