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
        //Create a list of available years, make sure each entry is unique
        let years = Set(quarterlyUsageRecords.map { $0.year }).sorted()
        var previousQuarter: QuarterlyUsageRecord?
        
        for year in years {
            //Make sure the quarters are in ascending order -> [Q1, Q2, Q3, Q4]
            let filteredArray = quarterlyUsageRecords.filter {$0.year == year}.sorted {
                $0.quarter < $1.quarter
            }
            do {
                //Pass the last quarter from previous year while creating annual usage object. This is to verify if data usage dropped in Q1 in comparison to Q4 of last year.
                let annualDataUsage = try AnnualDataUsage.init(year: year,
                                                           quarterlyUsageRecords: filteredArray,
                                                           previousQuarter: previousQuarter)
                self.annualDataUsageRecords?.append(annualDataUsage)
                previousQuarter = filteredArray.last
            } catch {
                print("Annual data usage creation skipped.")
            }
        }
    }
}

class AnnualDataUsage {
    let year: String
    var totalUsage: Double
    var qoqVolumeDecreased: Bool
    var decreasedQuarters: [String]
    let quarterlyUsageRecords: [QuarterlyUsageRecord]
    
    init(year:String, quarterlyUsageRecords:[QuarterlyUsageRecord], previousQuarter:QuarterlyUsageRecord?) throws {
        
        guard year.count > 0 else {
            throw DataListingViewModelErrors.invalidYearString
        }
        guard quarterlyUsageRecords.count >= 1 else {
            throw DataListingViewModelErrors.invalidQuartelyRecordsArray
        }
        
        self.year = year
        self.quarterlyUsageRecords = quarterlyUsageRecords
        self.decreasedQuarters = [String]()
        self.qoqVolumeDecreased = false
        self.totalUsage = 0.0
        
        var previousQuarter = previousQuarter
        
        for quarterlyRecord in quarterlyUsageRecords {
            
            self.totalUsage += quarterlyRecord.dataUsage
            
            if previousQuarter != nil, previousQuarter!.dataUsage > quarterlyRecord.dataUsage {
                self.qoqVolumeDecreased = true
                self.decreasedQuarters.append(quarterlyRecord.quarter)
            }
            
            previousQuarter = quarterlyRecord
        }
    }
}
