//
//  DataUsageListingViewModel.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 6/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation

class DataUsageListingViewModel {
    
    let quarterlyUsageRecords: [QuarterlyUsageRecord]
    
    init(quarterlyUsageRecords:[QuarterlyUsageRecord]) {
        self.quarterlyUsageRecords = quarterlyUsageRecords
    }
    
    func getDataUsageForAllYears() -> [String:String] {
        return ["2019":"12.12345"]
    }
    
    func qoqVolumeDecreased(year:String) -> Bool {
        return true
    }
    
    func quarterlyRecords(for year:String) -> [QuarterlyUsageRecord] {
        return [QuarterlyUsageRecord]()
    }
}
