//
//  DataUsageModel.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation

class DataUsageRequest {
    let previousPage : Int
    
    init(previousPage:Int) {
        self.previousPage = previousPage
    }
    
    func fetchMobileDataUsage(onSuccess successBlock:@escaping(DataUsageResponse)->Void,
        onFailure:@escaping(NSError)->Void) {
        
        NetworkManager.sharedInstance.getRequest(apiConstants.queryEndpoint,
                                                 params: nil,
                                                 onSuccess: { (responseJSON) in
                                                    
        }) { (error) in
            
        }
    }
}

class DataUsageResponse {
    
    func initWithJSON(_ responseJSON:[String:Any]) {
        
    }
}

class AnnualDataUsage {
    
}
