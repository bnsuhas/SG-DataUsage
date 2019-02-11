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
                                                    if let result = responseJSON[dataUsageJSONConstants.resultKey] as? [String: Any]
                                                    {
                                                        do {
                                                            let dataUsageResponse = try DataUsageResponse.init(result)
                                                            successBlock(dataUsageResponse)
                                                        } catch {
                                                            let error = NSError.init(domain: networkErrorConstants.networkErrorDomain, code:networkErrorConstants.parsingError ,
                                                                                     userInfo: [NSLocalizedDescriptionKey:"JSON format error"])
                                                            failureBlock(error)
                                                        }
                                                    } else {
                                                        let error = NSError.init(domain: networkErrorConstants.networkErrorDomain, code:networkErrorConstants.parsingError ,
                                                                                 userInfo: [NSLocalizedDescriptionKey:"JSON format error"])
                                                        failureBlock(error)
                                                    }
                                            
        }) { (error) in
            failureBlock(error)
        }
    }
}

class DataUsageResponse {
    
    var quarterlyUsageRecords = [QuarterlyUsageRecord]()
    
      init(_ responseJSON:[String:Any]) throws {
        if let dataUsageRecords = responseJSON[dataUsageJSONConstants.recordsKey] as? Array<[String: Any]> {
            for dataUsageRecord in dataUsageRecords {
                quarterlyUsageRecords.append(QuarterlyUsageRecord.init(dictionary: dataUsageRecord))
            }            
        } else {
            throw DataUsageModelErrors.invalidJSON
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
        let id = dictionary[dataUsageJSONConstants.idKey] as? Int ?? -1
        let dataUsage = Double(dictionary[dataUsageJSONConstants.volumeKey] as? String ?? "0.0")!
        var year = ""
        var quarter = ""
        
        if let quarterDetals = dictionary[dataUsageJSONConstants.quarterKey] as? String
        {
            let parts = quarterDetals.split(separator: "-")
            
            if(parts.count == 2)
            {
                year = String(parts.first ?? "")
                quarter = String(parts.last ?? "")
            }
        }
        
        self.init(id: id, year: year, quarter: quarter, dataUsage: dataUsage)
    }
}
