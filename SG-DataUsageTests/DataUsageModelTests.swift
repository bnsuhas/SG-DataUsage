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
        mockSession.data = Data.init(base64Encoded:"ewoiaGVscCI6ICJodHRwczovL2RhdGEuZ292LnNnL2FwaS8zL2FjdGlvbi9oZWxwX3Nob3c/bmFtZT1kYXRhc3RvcmVfc2VhcmNoIiwKInN1Y2Nlc3MiOiB0cnVlLAoicmVzdWx0IjogewoicmVzb3VyY2VfaWQiOiAiYTgwN2I3YWItNmNhZC00YWE2LTg3ZDAtZTI4M2E3MzUzYTBmIiwKImZpZWxkcyI6IFsKewoidHlwZSI6ICJpbnQ0IiwKImlkIjogIl9pZCIKfSwKewoidHlwZSI6ICJ0ZXh0IiwKImlkIjogInF1YXJ0ZXIiCn0sCnsKInR5cGUiOiAibnVtZXJpYyIsCiJpZCI6ICJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiCn0KXSwKInJlY29yZHMiOiBbCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIwLjAwMDM4NCIsCiJxdWFydGVyIjogIjIwMDQtUTMiLAoiX2lkIjogMQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMC4wMDA1NDMiLAoicXVhcnRlciI6ICIyMDA0LVE0IiwKIl9pZCI6IDIKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjAuMDAwNjIiLAoicXVhcnRlciI6ICIyMDA1LVExIiwKIl9pZCI6IDMKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjAuMDAwNjM0IiwKInF1YXJ0ZXIiOiAiMjAwNS1RMiIsCiJfaWQiOiA0Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIwLjAwMDcxOCIsCiJxdWFydGVyIjogIjIwMDUtUTMiLAoiX2lkIjogNQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMC4wMDA4MDEiLAoicXVhcnRlciI6ICIyMDA1LVE0IiwKIl9pZCI6IDYKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjAuMDAwODkiLAoicXVhcnRlciI6ICIyMDA2LVExIiwKIl9pZCI6IDcKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjAuMDAxMTg5IiwKInF1YXJ0ZXIiOiAiMjAwNi1RMiIsCiJfaWQiOiA4Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIwLjAwMTczNSIsCiJxdWFydGVyIjogIjIwMDYtUTMiLAoiX2lkIjogOQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMC4wMDMzMjMiLAoicXVhcnRlciI6ICIyMDA2LVE0IiwKIl9pZCI6IDEwCn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIwLjAxMjYzNSIsCiJxdWFydGVyIjogIjIwMDctUTEiLAoiX2lkIjogMTEKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjAuMDI5OTkyIiwKInF1YXJ0ZXIiOiAiMjAwNy1RMiIsCiJfaWQiOiAxMgp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMC4wNTM1ODQiLAoicXVhcnRlciI6ICIyMDA3LVEzIiwKIl9pZCI6IDEzCn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIwLjEwMDkzNCIsCiJxdWFydGVyIjogIjIwMDctUTQiLAoiX2lkIjogMTQKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjAuMTcxNTg2IiwKInF1YXJ0ZXIiOiAiMjAwOC1RMSIsCiJfaWQiOiAxNQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMC4yNDg4OTkiLAoicXVhcnRlciI6ICIyMDA4LVEyIiwKIl9pZCI6IDE2Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIwLjQzOTY1NSIsCiJxdWFydGVyIjogIjIwMDgtUTMiLAoiX2lkIjogMTcKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjAuNjgzNTc5IiwKInF1YXJ0ZXIiOiAiMjAwOC1RNCIsCiJfaWQiOiAxOAp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMS4wNjY1MTciLAoicXVhcnRlciI6ICIyMDA5LVExIiwKIl9pZCI6IDE5Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIxLjM1NzI0OCIsCiJxdWFydGVyIjogIjIwMDktUTIiLAoiX2lkIjogMjAKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjEuNjk1NzA0IiwKInF1YXJ0ZXIiOiAiMjAwOS1RMyIsCiJfaWQiOiAyMQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMi4xMDk1MTYiLAoicXVhcnRlciI6ICIyMDA5LVE0IiwKIl9pZCI6IDIyCn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIyLjMzNjMiLAoicXVhcnRlciI6ICIyMDEwLVExIiwKIl9pZCI6IDIzCn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIyLjc3NzgxNyIsCiJxdWFydGVyIjogIjIwMTAtUTIiLAoiX2lkIjogMjQKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjMuMDAyMDkxIiwKInF1YXJ0ZXIiOiAiMjAxMC1RMyIsCiJfaWQiOiAyNQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMy4zMzY5ODQiLAoicXVhcnRlciI6ICIyMDEwLVE0IiwKIl9pZCI6IDI2Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIzLjQ2NjIyOCIsCiJxdWFydGVyIjogIjIwMTEtUTEiLAoiX2lkIjogMjcKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjMuMzgwNzIzIiwKInF1YXJ0ZXIiOiAiMjAxMS1RMiIsCiJfaWQiOiAyOAp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMy43MTM3OTIiLAoicXVhcnRlciI6ICIyMDExLVEzIiwKIl9pZCI6IDI5Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICI0LjA3Nzk2IiwKInF1YXJ0ZXIiOiAiMjAxMS1RNCIsCiJfaWQiOiAzMAp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiNC42Nzk0NjUiLAoicXVhcnRlciI6ICIyMDEyLVExIiwKIl9pZCI6IDMxCn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICI1LjMzMTU2MiIsCiJxdWFydGVyIjogIjIwMTItUTIiLAoiX2lkIjogMzIKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjUuNjE0MjAxIiwKInF1YXJ0ZXIiOiAiMjAxMi1RMyIsCiJfaWQiOiAzMwp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiNS45MDMwMDUiLAoicXVhcnRlciI6ICIyMDEyLVE0IiwKIl9pZCI6IDM0Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICI1LjgwNzg3MiIsCiJxdWFydGVyIjogIjIwMTMtUTEiLAoiX2lkIjogMzUKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjcuMDUzNjQyIiwKInF1YXJ0ZXIiOiAiMjAxMy1RMiIsCiJfaWQiOiAzNgp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiNy45NzA1MzYiLAoicXVhcnRlciI6ICIyMDEzLVEzIiwKIl9pZCI6IDM3Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICI3LjY2NDgwMiIsCiJxdWFydGVyIjogIjIwMTMtUTQiLAoiX2lkIjogMzgKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjcuNzMwMTgiLAoicXVhcnRlciI6ICIyMDE0LVExIiwKIl9pZCI6IDM5Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICI3LjkwNzc5OCIsCiJxdWFydGVyIjogIjIwMTQtUTIiLAoiX2lkIjogNDAKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjguNjI5MDk1IiwKInF1YXJ0ZXIiOiAiMjAxNC1RMyIsCiJfaWQiOiA0MQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiOS4zMjc5NjciLAoicXVhcnRlciI6ICIyMDE0LVE0IiwKIl9pZCI6IDQyCn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICI5LjY4NzM2MyIsCiJxdWFydGVyIjogIjIwMTUtUTEiLAoiX2lkIjogNDMKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjkuOTg2NzciLAoicXVhcnRlciI6ICIyMDE1LVEyIiwKIl9pZCI6IDQ0Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIxMC45MDIxOTQiLAoicXVhcnRlciI6ICIyMDE1LVEzIiwKIl9pZCI6IDQ1Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIxMC42NzcxNjYiLAoicXVhcnRlciI6ICIyMDE1LVE0IiwKIl9pZCI6IDQ2Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIxMC45NjczMyIsCiJxdWFydGVyIjogIjIwMTYtUTEiLAoiX2lkIjogNDcKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjExLjM4NzM0IiwKInF1YXJ0ZXIiOiAiMjAxNi1RMiIsCiJfaWQiOiA0OAp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMTIuMTQyMzIiLAoicXVhcnRlciI6ICIyMDE2LVEzIiwKIl9pZCI6IDQ5Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIxMi44NjQyOSIsCiJxdWFydGVyIjogIjIwMTYtUTQiLAoiX2lkIjogNTAKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjEzLjI5NzU3IiwKInF1YXJ0ZXIiOiAiMjAxNy1RMSIsCiJfaWQiOiA1MQp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMTQuNTQxNzkiLAoicXVhcnRlciI6ICIyMDE3LVEyIiwKIl9pZCI6IDUyCn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIxNC44ODQ2MyIsCiJxdWFydGVyIjogIjIwMTctUTMiLAoiX2lkIjogNTMKfSwKewoidm9sdW1lX29mX21vYmlsZV9kYXRhIjogIjE1Ljc3NjUzIiwKInF1YXJ0ZXIiOiAiMjAxNy1RNCIsCiJfaWQiOiA1NAp9LAp7CiJ2b2x1bWVfb2ZfbW9iaWxlX2RhdGEiOiAiMTYuNDcxMjEiLAoicXVhcnRlciI6ICIyMDE4LVExIiwKIl9pZCI6IDU1Cn0sCnsKInZvbHVtZV9vZl9tb2JpbGVfZGF0YSI6ICIxOC40NzM2OCIsCiJxdWFydGVyIjogIjIwMTgtUTIiLAoiX2lkIjogNTYKfQpdLAoiX2xpbmtzIjogewoic3RhcnQiOiAiL2FwaS9hY3Rpb24vZGF0YXN0b3JlX3NlYXJjaD9yZXNvdXJjZV9pZD1hODA3YjdhYi02Y2FkLTRhYTYtODdkMC1lMjgzYTczNTNhMGYiLAoibmV4dCI6ICIvYXBpL2FjdGlvbi9kYXRhc3RvcmVfc2VhcmNoP29mZnNldD0xMDAmcmVzb3VyY2VfaWQ9YTgwN2I3YWItNmNhZC00YWE2LTg3ZDAtZTI4M2E3MzUzYTBmIgp9LAoidG90YWwiOiA1Ngp9Cn0=")
        
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
