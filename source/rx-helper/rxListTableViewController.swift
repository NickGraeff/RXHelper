//
//  rxListTableViewController.swift
//  rx-helper
//
//  Created by Work-Account on 10/14/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import SwiftyJSON

class rxListTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let rxlist = try! JSON(data: NSData(contentsOfFile: Bundle.main.path(forResource: "rxList01", ofType: "json")!)! as Data)
    var filteredRxList = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.setContentOffset(CGPoint(x: 0, y: searchController.searchBar.frame.size.height), animated: false)
        
    }
    /*override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }*/
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredRxList.count
        }
        return rxlist.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxCell", for: indexPath)
        
        var data: JSON
        
        if searchController.isActive && searchController.searchBar.text != "" {
            data = filteredRxList[indexPath.row]
        }else{
            data = rxlist[indexPath.row]
        }
        // Configure the cell...
        //print(data[][])
        let countryName = data["term"].stringValue
        let countryCapital = data[" "].stringValue
        
        cell.textLabel?.text = countryName
        cell.detailTextLabel?.text = countryCapital
        
        return cell
    }
    
    func filteredContentForSearchText(searchText: String){
        filteredRxList = rxlist.array!.filter { country in
            return country["term"].stringValue.localizedLowercase.contains(searchText.localizedLowercase)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "medDetailsViewController") as? medDetailsViewController
        var data: JSON
        data = rxlist[indexPath.row]
        let countryName = data["term"].stringValue
        vc?.name = countryName
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

extension rxListTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
