//
//  RootViewController.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 zapr. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: BaseViewController
{
    override func viewDidLoad() {
        
        let dataUsageListingVC = self.initViewController(DataUsageListingUIConstants.initialControllerIdentifier, storyboardName: DataUsageListingUIConstants.storyboardName)
        self.addChildVC(dataUsageListingVC)
    }
}
