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
        
        self.tableView.backgroundColor = UIColor.lightGray
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.setContentOffset(CGPoint(x: 0, y: searchController.searchBar.frame.size.height), animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
            navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        
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
        if isFiltering(){
            return filteredRxList.count
        }
        return rxlist.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxCell", for: indexPath)
        
        var data: JSON
        
        if searchController.isActive && searchController.searchBar.text != "" {
            data = filteredRxList[indexPath.row]
            let countryName = data["term"].stringValue
            
            cell.textLabel?.text = countryName
        }else{
            data = rxlist[indexPath.row]
            tableView.reloadData()
        }
        
        return cell
    }
    
    func filteredContentForSearchText(searchText: String){
        filteredRxList = rxlist.array!.filter { country in
            return country["term"].stringValue.localizedLowercase.contains(searchText.localizedLowercase)
        }
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
        
    }
    
    
    func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreinfo"{
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let data: JSON
                if isFiltering(){
                    data = filteredRxList[indexPath.row]
                    
                }else{
                    data = rxlist[indexPath.row]
                    
                }
                let controller = segue.destination as? medDetailsViewController
                let final = data["term"].stringValue
                controller?.name = final
                controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
}

extension rxListTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
        searchController.searchResultsController?.view.isHidden = false;
    }
}
