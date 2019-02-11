//
//  DataUsageListViewController.swift
//  SG-DataUsage
//
//  Created by Suhas BN on 5/2/19.
//  Copyright © 2019 FrisbeeLabs. All rights reserved.
//

import UIKit

class DataUsageListingCell: UITableViewCell {
    @IBOutlet weak var roundedRectView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var usageDropButton: UIButton!
    
    weak var delegate: DataUsageListingCellDelegate?
    
    @IBAction func usageDropButtonTapped(_ sender: UIButton) {
        self.delegate?.showVolumeDropDetails(for: sender.tag)
    }
}

protocol DataUsageListingCellDelegate: class {
    func showVolumeDropDetails(for row:Int)
}

class DataUsageListViewController: UITableViewController, DataUsageListingCellDelegate
{
    var viewModel : DataUsageListingViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        self.tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.beginRefreshing()
        
        let dataUsageRequest = DataUsageRequest()
        dataUsageRequest.fetchMobileDataUsage(onSuccess: { (dataUsageResponse) in
            
            self.storeDataForOfflineUsage(dataUsageResponse.quarterlyUsageRecords)
            
            self.viewModel = DataUsageListingViewModel.init(quarterlyUsageRecords: dataUsageResponse.quarterlyUsageRecords)
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                
                if error.code == networkErrorConstants.notReachable
                {
                    DispatchQueue.main.async {
                        self.displayStoredData()
                    }
                }
                else {
                    self.showAlertWithTitle("Couldn't fetch data usage details",
                                            message:error.localizedDescription,
                                            cancelButtonTitle: "Ok")
                }
            }
        }
    }
    
    //MARK: - DataUsageListingCellDelegate Methods
    
    func showVolumeDropDetails(for row: Int) {
        
        let annualDataUsageRecord = self.viewModel!.annualDataUsageRecords![row]

        var errorMessage = "Data usage volume dropped in"
        
        for quarter in annualDataUsageRecord.decreasedQuarters {
            errorMessage = errorMessage + "\n-\(quarter)"
        }
        
        self.showAlertWithTitle("Volume Dropped",
                                message:errorMessage,
                                cancelButtonTitle: "Ok")
    }
    
    //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.annualDataUsageRecords?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataUsageCell") as! DataUsageListingCell
        
        let annualDataUsageRecord = self.viewModel!.annualDataUsageRecords![indexPath.row]
        
        cell.yearLabel.text = "Year: "+"\(annualDataUsageRecord.year)"
        cell.volumeLabel.text = String.init(format:"%.4f", annualDataUsageRecord.totalUsage)
        
        if annualDataUsageRecord.qoqVolumeDecreased
        {
            cell.usageDropButton.isHidden = false
            cell.usageDropButton.tag = indexPath.row
            cell.delegate = self
            cell.roundedRectView.backgroundColor = colorConstants.usageDecreasedCellColor
        }
        else
        {
            cell.usageDropButton.isHidden = true
            cell.usageDropButton.tag = -1
            cell.delegate = nil
            cell.roundedRectView.backgroundColor = colorConstants.defaultCellColor
        }
        
        return cell
    }
    
    //MARK: - Instance Methods
    
    func storeDataForOfflineUsage(_ quarterlyUsageRecords:[QuarterlyUsageRecord]) {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject:quarterlyUsageRecords,
                                                        requiringSecureCoding: false)
        {
            UserDefaults.standard.set(data, forKey: dataUsageListingUIConstants.savedDataKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func displayStoredData() {
        
        let errorBlock :()->() = {
            self.showAlertWithTitle("Couldn't fetch data usage details",
                                    message: "Please check your network connection and try again later.", cancelButtonTitle: "ok")
        }
        
            if let data = UserDefaults.standard.value(forKey: dataUsageListingUIConstants.savedDataKey) as? Data
            {
                do {
                    let quarterlyUsageRecords = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [QuarterlyUsageRecord]
                    self.viewModel = DataUsageListingViewModel.init(quarterlyUsageRecords: quarterlyUsageRecords!)
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    
                    self.showAlertWithTitle("Offline Mode", message:"You are currently viewing offline data", cancelButtonTitle: "ok")
                } catch {
                    errorBlock()
                }
            }else {
                errorBlock()
        }
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

