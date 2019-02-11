//
//  DataUsageListingConstants.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation

struct dataUsageListingUIConstants {
    static let storyboardName = "DataUsageListing"
    static let initialControllerIdentifier = "DataListingNavigationController"
    static let savedDataKey = "savedData"
}

struct dataUsageJSONConstants {
    static let resourceID = "resource_id"
    static let limitKey = "limit"
    static let offsetKey = "offset"
    static let resultKey = "result"
    static let recordsKey = "records"
    static let idKey = "_id"
    static let volumeKey = "volume_of_mobile_data"
    static let quarterKey = "quarter"
}

struct dataUsageViewModelConstants {
    static let yearKey = "year"
    static let volumeKey = "volume"
}

enum DataUsageModelErrors: Error {
    case invalidJSON
}

enum DataListingViewModelErrors: Error {
    case invalidYearString
    case invalidQuartelyRecordsArray
}
