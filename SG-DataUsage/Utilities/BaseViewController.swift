//
//  BaseViewController.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController
{
    func addChildVC(_ childController: UIViewController) {
        
        childController.view.frame = self.view.frame
        self.view.addSubview(childController.view)
        
        self.addChild(childController)
    }
    
    func initViewController(_ identifier:String, storyboardName:String) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    func showAlertWithTitle(_ title:String, message:String, cancelButtonTitle:String){
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: cancelButtonTitle, style: .cancel) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
