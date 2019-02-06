//
//  NetworkManager.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    var urlSession : URLSession
    var reachability : Reachability
    
    private init () {
        let defaultConfiguration = URLSessionConfiguration.default
        self.urlSession = URLSession.init(configuration: defaultConfiguration)
        self.reachability = Reachability.forInternetConnection()
    }
    
    func httpRequest(_ urlPath:String, params: [String: Any]?, method: String, onSuccess
        successBlock:@escaping ([String:Any])->Void, onFailure failureBlock:@escaping (NSError)->Void) {
        
        if reachability.isReachableViaWiFi() == false && reachability.isReachableViaWWAN() == false
        {
            let errorObject = self.errorObjectFromString("No network connection detected", errorCode: networkErrorConstants.notReachable)
            failureBlock(errorObject)
            
            return
        }
        
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
                            do{
                                if let jsonObject = try JSONSerialization.jsonObject(with: responseData,
                                options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                                {
                                    successBlock(jsonObject)
                                }
                            } catch let error as NSError {
                                failureBlock(error)
                            }
                        }
                    } else {
                        
                        let localizedErrorString = HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode)
                        let errorObject = self.errorObjectFromString(localizedErrorString,
                                                                     errorCode: urlResponse.statusCode)
                        failureBlock(errorObject)
                    }
                } else {
                    
                    let errorObject = self.errorObjectFromString("Couldn't parse the response", errorCode: networkErrorConstants.parsingError)
                    failureBlock(errorObject)
                }
            } else {
                
                let errorObject = self.errorObjectFromString(error!.localizedDescription, errorCode: networkErrorConstants.urlSessionError)
                failureBlock(errorObject)
            }
        }
        dataTask.resume()
    }
    
    func getRequest(_ urlPath:String, params: [String: Any]?, onSuccess successBlock:@escaping ([String:Any])->Void, onFailure failureBlock:@escaping (NSError)->Void) {
        
        self.httpRequest(urlPath, params: params, method: "GET", onSuccess: successBlock, onFailure: failureBlock)
    }
    
    func errorObjectFromString(_ errorString:String, errorCode:Int) -> NSError
    {
        let error = NSError.init(domain: networkErrorConstants.networkErrorDomain,
                                 code: errorCode,
                                 userInfo: [NSLocalizedDescriptionKey:errorString])
        
        return error
    }
}
