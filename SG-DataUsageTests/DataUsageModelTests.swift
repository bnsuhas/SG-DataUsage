//
//  DataUsageModelTests.swift
//  SG-DataUsageTests
//
//  Created by Suhas BN on 11/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import XCTest
import Reachability

@testable import SG_DataUsage

class DataUsageModelTests: XCTestCase {
    
    var networkManagerToTest: NetworkManager?
    
    override func setUp() {
        networkManagerToTest = NetworkManager.sharedInstance
    }
    
    override func tearDown() {
        let defaultConfiguration = URLSessionConfiguration.default
        networkManagerToTest?.urlSession = URLSession.init(configuration: defaultConfiguration)
        networkManagerToTest?.reachability = Reachability.forInternetConnection()
    }
    
    func testQuarterlyUsageRecordInitWithEmptyDict() {
        let recordDict = [String:Any]()
        
        let quarterlyRecord = QuarterlyUsageRecord.init(dictionary: recordDict)
        XCTAssertEqual(-1, quarterlyRecord.id, "Record ID should be -1 if dictionary is empty")
    }
    
    func testQuarterlyUsageRecordInitWithNoHyphenQuarter() {
        let recordDict = ["volume_of_mobile_data": "14.88463",
                          "quarter": "2017Q3",
                          "_id": 53] as [String : Any]
        
        let quarterlyRecord = QuarterlyUsageRecord.init(dictionary: recordDict)
        XCTAssertEqual("", quarterlyRecord.quarter, "Quarter should be empty if detail is separated by hyphen")
    }
    
    func testDataUsageResponseInitWithEmptyJSON() {
        let responseJSON = [String:Any]()
        XCTAssertThrowsError(try DataUsageResponse.init(responseJSON))
    }
    
    func testDataUsageResponseInitWithCorruptJSON() {
        let responseJSON = ["volume_of_mobile_data": "14.88463",
                            "quarter": "2017Q3",
                            "_id": 53] as [String : Any]
        
        XCTAssertThrowsError(try DataUsageResponse.init(responseJSON))
    }
    
    func testDataUsageRequestErrorResponse() {
        
        let mockSession = URLSessionMock()
        mockSession.data = nil
        mockSession.response = HTTPURLResponse.init(url: URL.init(string:"https://www.google.com")! ,
                                                    statusCode: 500,
                                                    httpVersion: nil,
                                                    headerFields: nil)
        mockSession.error = nil
        
        let mockReachability = ReachabilityMock.forInternetConnection() as! ReachabilityMock
        mockReachability.reachableViaWifi = true
        mockReachability.reachableViaWWAN = true
        
        networkManagerToTest?.urlSession = mockSession
        networkManagerToTest?.reachability = mockReachability
        
        let dataUsageRequest = DataUsageRequest.init(previousPage: 0)
        dataUsageRequest.fetchMobileDataUsage(onSuccess: { (dataUsageResponse) in
            XCTAssert(false, "Success block should not be called if network call results in an error")
        }) { (errorObject) in
            XCTAssertEqual(500, errorObject.code, "Correct error code should be passed to the error block")
        }
    }
    
    func testDataUsageRequestSuccesResponseCorruptResults() {
        
        let mockSession = URLSessionMock()
        mockSession.data = Data.init(base64Encoded:"ewoiaGVscCI6ICJodHRwczovL2RhdGEuZ292LnNnL2FwaS8zL2FjdGlvbi9oZWxwX3Nob3c/bmFtZT1kYXRhc3RvcmVfc2VhcmNoIiwKInN1Y2Nlc3MiOiB0cnVlLAoicmVzdWx0IjogIiIKfQ==")
        
        mockSession.response = HTTPURLResponse.init(url: URL.init(string:"https://www.google.com")! ,
                                                    statusCode: 200,
                                                    httpVersion: nil,
                                                    headerFields: nil)
        mockSession.error = nil
        
        let mockReachability = ReachabilityMock.forInternetConnection() as! ReachabilityMock
        mockReachability.reachableViaWifi = true
        mockReachability.reachableViaWWAN = true
        
        networkManagerToTest?.urlSession = mockSession
        networkManagerToTest?.reachability = mockReachability
        
        let dataUsageRequest = DataUsageRequest.init(previousPage: 0)
        dataUsageRequest.fetchMobileDataUsage(onSuccess: { (dataUsageResponse) in
            XCTAssert(false, "Success block should not be called if network call results in an error")
        }) { (errorObject) in
            XCTAssertEqual(networkErrorConstants.parsingError, errorObject.code, "Correct error code should be passed to the error block")
        }
    }
    
    func testDataUsageRequestSuccesResponseCorruptRecords() {
    
    let mockSession = URLSessionMock()
    mockSession.data = Data.init(base64Encoded:"ewoiaGVscCI6ICJodHRwczovL2RhdGEuZ292LnNnL2FwaS8zL2FjdGlvbi9oZWxwX3Nob3c/bmFtZT1kYXRhc3RvcmVfc2VhcmNoIiwKInN1Y2Nlc3MiOiB0cnVlLAoicmVzdWx0IjogewoicmVzb3VyY2VfaWQiOiAiYTgwN2I3YWItNmNhZC00YWE2LTg3ZDAtZTI4M2E3MzUzYTBmIiwKInJlY29yZHMiOiBbCiJ0ZXN0IiwKInRlc3QiCl0sCiJfbGlua3MiOiB7CiJzdGFydCI6ICIvYXBpL2FjdGlvbi9kYXRhc3RvcmVfc2VhcmNoP3Jlc291cmNlX2lkPWE4MDdiN2FiLTZjYWQtNGFhNi04N2QwLWUyODNhNzM1M2EwZiIsCiJuZXh0IjogIi9hcGkvYWN0aW9uL2RhdGFzdG9yZV9zZWFyY2g/b2Zmc2V0PTEwMCZyZXNvdXJjZV9pZD1hODA3YjdhYi02Y2FkLTRhYTYtODdkMC1lMjgzYTczNTNhMGYiCn0sCiJ0b3RhbCI6IDU2Cn0KfQ==")
    
    mockSession.response = HTTPURLResponse.init(url: URL.init(string:"https://www.google.com")! ,
    statusCode: 200,
    httpVersion: nil,
    headerFields: nil)
    mockSession.error = nil
    
    let mockReachability = ReachabilityMock.forInternetConnection() as! ReachabilityMock
    mockReachability.reachableViaWifi = true
    mockReachability.reachableViaWWAN = true
    
    networkManagerToTest?.urlSession = mockSession
    networkManagerToTest?.reachability = mockReachability
    
    let dataUsageRequest = DataUsageRequest.init(previousPage: 0)
    dataUsageRequest.fetchMobileDataUsage(onSuccess: { (dataUsageResponse) in
    XCTAssert(false, "Success block should not be called if network call results in an error")
    }) { (errorObject) in
    XCTAssertEqual(networkErrorConstants.parsingError, errorObject.code, "Correct error code should be passed to the error block")
    }
    }
    
    func testDataUsageRequestSuccessResponse() {

        let mockSession = URLSessionMock()
        mockSession.data = Data.init(base64Encoded:"ewoiaGVscCI6ICJodHRwczovL2RhdGEuZ292LnNnL2FwaS8zL2FjdGlvbi9oZWxwX3Nob3c/bmFtZT1kYXRhc3RvcmVfc2VhcmNoIiwKInN1Y2Nlc3MiOiB0cnVlLAoicmVzdWx0IjogewoicmVzb3VyY2VfaWQiOiAiYTgwN2I3YWItNmNhZC00YWE2LTg3ZDAtZTI4M2E3MzUzYTBmIiwKInJlY29yZHMiOiBbCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIwLjAwMDM4NCIsCiJxdWFydGVyIjogIjIwMDQtUTMiLAoiX2lkIjogMQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMC4wMDAyODQiLAoicXVhcnRlciI6ICIyMDA0LVE0IiwKIl9pZCI6IDIKfSwKXSwKfQp9")
        
        mockSession.response = HTTPURLResponse.init(url: URL.init(string:"https://www.google.com")! ,
                                                    statusCode: 200,
                                                    httpVersion: nil,
                                                    headerFields: nil)
        mockSession.error = nil
        
        let mockReachability = ReachabilityMock.forInternetConnection() as! ReachabilityMock
        mockReachability.reachableViaWifi = true
        mockReachability.reachableViaWWAN = true
        
        networkManagerToTest?.urlSession = mockSession
        networkManagerToTest?.reachability = mockReachability
        
        let dataUsageRequest = DataUsageRequest.init(previousPage: 0)
        dataUsageRequest.fetchMobileDataUsage(onSuccess: { (dataUsageResponse) in
            XCTAssertNotNil(dataUsageResponse, "Success block should return a non null response object")
        }) { (errorObject) in
            XCTAssert(false, "Failure block should not be called even if proper data is passed to the request block.")
        }
    }
}
