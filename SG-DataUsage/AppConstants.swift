//
//  AppConstants.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation
import UIKit

struct apiConstants {
    static let baseURL = "https://data.gov.sg/api/"
    static let queryEndpoint = "action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
}

struct networkErrorConstants {
    static let networkErrorDomain = "com.networkErrorDomain"
    static let urlSessionError = 0
    static let notReachable = 1
    static let parsingError = 2
}

struct colorConstants {
    static let defaultCellColor = UIColor.init(red: 139.0/255.0, green: 216.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    static let usageDecreasedCellColor = UIColor.init(red: 234.0/255.0, green: 113.0/255.0, blue: 134.0/255.0, alpha: 1.0)
}
