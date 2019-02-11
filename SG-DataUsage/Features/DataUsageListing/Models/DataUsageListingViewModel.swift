//
//  DataUsageListingViewModel.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 6/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation

class DataUsageListingViewModel {
    
    var annualDataUsageRecords: [AnnualDataUsage]?
    
    init(quarterlyUsageRecords:[QuarterlyUsageRecord]) {
        self.annualDataUsageRecords = [AnnualDataUsage]()
        let years = Set(quarterlyUsageRecords.map { $0.year }).sorted()
        
        for year in years {
            let filteredArray = quarterlyUsageRecords.filter {$0.year == year}
            let annualDataUsage = AnnualDataUsage.init(year: year,
                                                       quarterlyUsageRecords: filteredArray,
                                                       previousQuarter: nil)
            self.annualDataUsageRecords?.append(annualDataUsage)
        }
    }
    
    func qoqVolumeDecreased(year:String) -> Bool {
        return true
    }
    
    func quarterlyRecords(for year:String) -> [QuarterlyUsageRecord] {
        return [QuarterlyUsageRecord]()
    }
}

class AnnualDataUsage {
    let year: String
    var totalUsage: Double
    var qoqVolumeDecreased: Bool
    let quarterlyUsageRecords: [QuarterlyUsageRecord]
    
    init(year:String, quarterlyUsageRecords:[QuarterlyUsageRecord], previousQuarter:QuarterlyUsageRecord?) {
        self.year = year
        self.quarterlyUsageRecords = quarterlyUsageRecords
        self.qoqVolumeDecreased = false
        self.totalUsage = 0.0
        
        var previousQuarter = previousQuarter
        
        for quarterlyRecord in quarterlyUsageRecords {
            
            self.totalUsage += quarterlyRecord.dataUsage
            
            if previousQuarter != nil, previousQuarter!.dataUsage > quarterlyRecord.dataUsage {
                self.qoqVolumeDecreased = true
                break
            } else {
                previousQuarter = quarterlyRecord
            }
        }
    }
}
