//
//  ReachabilityMock.swift
//  SG-DataUsageTests
//
//  Created by Suhas BN on 6/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityMock: Reachability
{
    var reachableViaWifi = false
    var reachableViaWWAN = false
    
    override func isReachableViaWiFi() -> Bool {
       return reachableViaWifi
    }
    
    override func isReachableViaWWAN() -> Bool {
       return reachableViaWWAN
    }
}
