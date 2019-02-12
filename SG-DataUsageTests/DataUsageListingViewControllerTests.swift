//
//  DataUsageListingViewControllerTests.swift
//  SG-DataUsageTests
//
//  Created by Suhas BN on 12/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import XCTest
import Reachability

@testable import SG_DataUsage

class DataUsageListingViewControllerTests: XCTestCase {
    
    var listingViewControllerToTest : DataUsageListViewController?
    
    override func setUp() {
        listingViewControllerToTest = DataUsageListViewController()
        listingViewControllerToTest?.tableView = UITableView()
    }
    
    override func tearDown() {
        listingViewControllerToTest?.tableView = nil
        listingViewControllerToTest = nil
    }
    
    func testSavingRecordsToUserDefaults() {
    
        let mockUserDefaults = UserDefaultsMock.init(suiteName: "TestSuite")
        let usageRecord = QuarterlyUsageRecord.init(id: 1, year: "2014", quarter: "Q4", dataUsage: 123.456)
        
        let success = listingViewControllerToTest!.storeDataForOfflineUsage([usageRecord], userDefaults: mockUserDefaults!)
        XCTAssertTrue(success)
    }
    
    func testSavingEmptyRecordsToUserDefaults() {
        
        let mockUserDefaults = UserDefaultsMock.init(suiteName: "TestSuite")
        
        let success = listingViewControllerToTest!.storeDataForOfflineUsage([QuarterlyUsageRecord](), userDefaults: mockUserDefaults!)
        XCTAssertFalse(success)
    }
}
