//
//  NetworkManagerTests.swift
//  SG-DataUsageTests
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import XCTest
import Reachability

@testable import SG_DataUsage

class NetworkManagerTests: XCTestCase {
    
    var networkManagerToTest: NetworkManager?

    override func setUp() {
        networkManagerToTest = NetworkManager.sharedInstance
    }

    override func tearDown() {
        let defaultConfiguration = URLSessionConfiguration.default
        networkManagerToTest?.urlSession = URLSession.init(configuration: defaultConfiguration)
        networkManagerToTest?.reachability = Reachability.forInternetConnection()
    }

    func testInternalServerError() {
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
        
        networkManagerToTest?.httpRequest("test",
                                          params: nil,
                                          method: "GET",
                                          onSuccess: { (responseData) in
                                            XCTFail("Success block should not be called if there is an internal server error.")
        },
                                          onFailure: { (error) in
                                            XCTAssertEqual(500, error.code, "Error object should return error code 500")
        })
    }
    
    func testNoInternetConnection() {
        let mockReachability = ReachabilityMock.forInternetConnection() as! ReachabilityMock
        mockReachability.reachableViaWifi = false
        mockReachability.reachableViaWWAN = false
        
        networkManagerToTest?.reachability = mockReachability
        
        networkManagerToTest?.httpRequest("test",
                                          params: nil,
                                          method: "GET",
                                          onSuccess: { (responseData) in
                                            XCTFail("Success block should not be called if there is no network connection.")
        },
                                          onFailure: { (error) in
                                            XCTAssertEqual(networkErrorConstants.notReachable, error.code, "Error object should return error code 1")
        })
    }
    
    func testCorruptJSONData() {
        let mockSession = URLSessionMock()
        mockSession.data = Data.init(base64Encoded:"VGhpcyBpcyBub3QgYSBKU09O")
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
        
        networkManagerToTest?.httpRequest("test",
                                          params: nil,
                                          method: "GET",
                                          onSuccess: { (responseData) in
                                            XCTFail("Success block should not be called if JSON data is corrupt")
        },
                                          onFailure: { (error) in
                                            XCTAssertNotNil(error, "Error object should be returned if JSON data is corrupt")
        })
    }    
}
