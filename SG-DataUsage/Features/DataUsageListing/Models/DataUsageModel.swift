//
//  DataUsageModel.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation

class DataUsageRequest {
    
    func fetchMobileDataUsage(onSuccess successBlock:@escaping(DataUsageResponse)->Void,
        onFailure failureBlock:@escaping(NSError)->Void) {
        
        //Fetch Mobile Data Usage Volume from the API
        NetworkManager.sharedInstance.getRequest(apiConstants.queryEndpoint,
                                                 params: nil,
                                                 onSuccess: { (responseJSON) in
                                                    
                                                    //JSON is not formatted properly, call the failureBlock
                                                    if let result = responseJSON[dataUsageJSONConstants.resultKey] as? [String: Any]
                                                    {
                                                        do {
                                                            //Create the response object
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
        
        //Check if the JSON data is in proper format, if not throw an error
        if let dataUsageRecords = responseJSON[dataUsageJSONConstants.recordsKey] as? Array<[String: Any]> {
            for dataUsageRecord in dataUsageRecords {
                quarterlyUsageRecords.append(QuarterlyUsageRecord.init(dictionary: dataUsageRecord))
            }            
        } else {
            throw DataUsageModelErrors.invalidJSON
        }
    }
}

class QuarterlyUsageRecord: NSObject, NSCoding
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
    
    func encode(with aCoder: NSCoder) {
        
        //Int and Double cannot be encoded, convert them to string before storing.
        aCoder.encode(String(self.id), forKey: dataUsageJSONConstants.idKey)
        aCoder.encode(String(self.dataUsage), forKey: dataUsageJSONConstants.volumeKey)
        aCoder.encode("\(self.year)-\(self.quarter)", forKey: dataUsageJSONConstants.quarterKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.id = Int(aDecoder.decodeObject(forKey:dataUsageJSONConstants.idKey) as? String ?? "-1")!
        self.dataUsage = Double(aDecoder.decodeObject(forKey:dataUsageJSONConstants.volumeKey) as? String ?? "0.0")!
        
        let quarterDetals = aDecoder.decodeObject(forKey:dataUsageJSONConstants.quarterKey) as! String
        let parts = quarterDetals.split(separator: "-")
        
        self.year = String(parts.first ?? "")
        self.quarter = String(parts.last ?? "")
    }
}
