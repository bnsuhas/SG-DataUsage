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
        onFailure failureBlock:@escaping(NSError)->Void) {
        
        NetworkManager.sharedInstance.getRequest(apiConstants.queryEndpoint,
                                                 params: nil,
                                                 onSuccess: { (responseJSON) in
                                                    if let result = responseJSON["result"] as? [String: Any]
                                                    {
                                                        let dataUsageResponse = DataUsageResponse.init(result)
                                                        successBlock(dataUsageResponse)
                                                    }
                                            
        }) { (error) in
            failureBlock(error)
        }
    }
}

class DataUsageResponse {
    
    var quarterlyUsageRecords = [QuarterlyUsageRecord]()
    
     init(_ responseJSON:[String:Any]) {
        if let dataUsageRecords = responseJSON["records"] as? Array<[String: Any]> {
            for dataUsageRecord in dataUsageRecords {
                quarterlyUsageRecords.append(QuarterlyUsageRecord.init(dictionary: dataUsageRecord))
            }
        }
    }
}

class QuarterlyUsageRecord
{
    let id: Int
    let year:String
    let quarter: String
    let dataUsage: Double
    
    init(id:Int, year:String,quarter:String, dataUsage:Double) {
        self.id = id
        self.year = year
        self.quarter = quarter
        self.dataUsage = dataUsage
    }
    
    convenience init(dictionary:[String: Any]) {
        let id = dictionary["_id"] as? Int ?? -1
        let dataUsage = Double(dictionary["volume_of_mobile_data"] as? String ?? "0.0")!
        var year = ""
        var quarter = ""
        
        if let quarterDetals = dictionary["quarter"] as? String
        {
            let parts = quarterDetals.split(separator: "-")
            year = String(parts.first ?? "")
            quarter = String(parts.last ?? "")
        }
        
        self.init(id: id, year: year, quarter: quarter, dataUsage: dataUsage)
    }
}
