//
//  rxListPetsTableViewController.swift
//  rx-helper
//
//  Created by Work-Account on 10/14/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import SwiftyJSON

class rxListPetsTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let rxlist = try! JSON(data: NSData(contentsOfFile: Bundle.main.path(forResource: "rxListPets", ofType: "json")!)! as Data)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering(){//searchController.isActive && searchController.searchBar.text != ""{
            return filteredRxList.count
        }
        //tableView.isHidden = true
        return rxlist.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rxCel", for: indexPath)
        
        var data: JSON
        
        if isFiltering(){//searchController.isActive && searchController.searchBar.text != "" {
            data = filteredRxList[indexPath.row]
            let countryName = data["term"].stringValue
            //let countryCapital = data[" "].stringValue
            
            cell.textLabel?.text = countryName
            //tableView.reloadData()
            //cell.detailTextLabel?.text = countryCapital
            
        }else{
            data = rxlist[indexPath.row]
            tableView.reloadData()
            //let countryName = data["term"].stringValue
        }
        
        //tableView.reloadData()
        
        // Configure the cell...
        //print(data[][])
        //let countryName = data["term"].stringValue
        //let countryCapital = data[" "].stringValue
        
        //cell.textLabel?.text = countryName
        //cell.detailTextLabel?.text = countryCapital
        
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
        if segue.identifier == "moreInfo"{
            //if var selectedRowIndex = self.tableView.indexPathForSelectedRow()
            //let mapViewController = segue.destination as! medDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                //let candy = rxlist[indexPath.row]/////////////
                // let countryName = candy["term"].stringValue
                //controller.name = countryName
                
                let data: JSON
                if isFiltering(){
                    data = filteredRxList[indexPath.row]
                    
                }else{
                    data = rxlist[indexPath.row]
                    
                }
              
                //let controller = (segue.destination as! UINavigationController).topViewController as! medDetailsViewController
                let controller = segue.destination as? medDetailsViewController
                let final = data["term"].stringValue
                controller?.name = final //countryName
                controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
   }
    
}

extension rxListPetsTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}


