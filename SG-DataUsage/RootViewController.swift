//
//  RootViewController.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: BaseViewController
{
    override func viewDidLoad() {
        
        let dataUsageListingVC = self.initViewController(dataUsageListingUIConstants.initialControllerIdentifier,
                                                         storyboardName: dataUsageListingUIConstants.storyboardName)
        self.addChildVC(dataUsageListingVC)
    }
}
