//
//  DataUsageListingViewModelTests.swift
//  SG-DataUsageTests
//
//  Created by Suhas BN on 11/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import XCTest
import Reachability

@testable import SG_DataUsage

class DataUsageListingViewModelTests: XCTestCase {
    
    var networkManagerToTest: NetworkManager?
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testDataUsageListingViewModelInit(){
        
        let quarterlyUsage1 = QuarterlyUsageRecord.init(id: 1, year: "2014", quarter: "Q1", dataUsage: 12.3456)
        let quarterlyUsage2 = QuarterlyUsageRecord.init(id: 2, year: "2014", quarter: "Q2", dataUsage: 12.3456)

        let viewModel = DataUsageListingViewModel.init(quarterlyUsageRecords: [quarterlyUsage1, quarterlyUsage2])
        XCTAssertEqual(1, viewModel.annualDataUsageRecords!.count)
    }
    
    func testAnnualDataUsageInitInvalidYear() {
        
        let quarterlyUsage = QuarterlyUsageRecord.init(id: 1, year: "2014", quarter: "Q1", dataUsage: 12.3456)
        
        XCTAssertThrowsError(try AnnualDataUsage.init(year: "",
                                                      quarterlyUsageRecords: [quarterlyUsage],
                                                      previousQuarter: nil))
    }
    
    func testAnnualDataUsageInitInvalidUasgeRecordArray() {
        
        XCTAssertThrowsError(try AnnualDataUsage.init(year: "2014",
                                                      quarterlyUsageRecords: [QuarterlyUsageRecord](),
                                                      previousQuarter: nil))
    }
    
    func testAnnualDataUsageInitSuccess() {
        let quarterlyUsage = QuarterlyUsageRecord.init(id: 1, year: "2014", quarter: "Q1", dataUsage: 12.3456)
        let annualUsage =  try? AnnualDataUsage.init(year: "2014", quarterlyUsageRecords: [quarterlyUsage],
                                 previousQuarter: nil)
        
        XCTAssertEqual(1, annualUsage?.quarterlyUsageRecords.count)
    }
}
