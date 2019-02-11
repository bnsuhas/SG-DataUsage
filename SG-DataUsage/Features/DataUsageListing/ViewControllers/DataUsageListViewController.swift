//
//  DataUsageListViewController.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import UIKit

class DataUsageListingCell: UITableViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
}

class DataUsageListViewController: UITableViewController
{
    var viewModel : DataUsageListingViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        self.tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.beginRefreshing()
        
        let dataUsageRequest = DataUsageRequest.init(previousPage: 0)
        dataUsageRequest.fetchMobileDataUsage(onSuccess: { (dataUsageResponse) in
            
            self.viewModel = DataUsageListingViewModel.init(quarterlyUsageRecords: dataUsageResponse.quarterlyUsageRecords)
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                let alert = UIAlertController.init(title:"Couldn't fetch data usage details",
                                                   message: error.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction.init(title:"Ok", style: .cancel) { (cancelAction) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.annualDataUsageRecords?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataUsageCell") as! DataUsageListingCell
        
        let annualDataUsageRecord = self.viewModel!.annualDataUsageRecords![indexPath.row]
        
        cell.yearLabel.text = "Year: "+"\(annualDataUsageRecord.year)"
        cell.volumeLabel.text = String(annualDataUsageRecord.totalUsage)
        
        return cell
    }
}

