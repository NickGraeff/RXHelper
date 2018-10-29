//
//  RxListPetsViewController.swift
//  rx-helper
//
//  Created by Work-Account on 10/29/18.
//  Copyright © 2018 cs477Team. All rights reserved.
//

import UIKit
import SwiftyJSON

class RxListPetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
    //@IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    let rxlist = try! JSON(data: NSData(contentsOfFile: Bundle.main.path(forResource: "rxListPet01", ofType: "json")!)! as Data)
    var filteredRxList = [JSON]()
    
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        searchBar.delegate = self
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{//searchController.isActive && searchController.searchBar.text != ""{
            return filteredRxList.count
        }
        return rxlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell02")
        
        var data: JSON
        
        if searching{//searchController.isActive && searchController.searchBar.text != "" {
            data = filteredRxList[indexPath.row]
            let countryName = data["term"].stringValue
            cell?.textLabel?.text = countryName
            
        }else{
            data = rxlist[indexPath.row]
            let countryName = data["term"].stringValue
            cell?.textLabel?.text = countryName
            tableView.reloadData()
        }
        return cell!
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("enter")
        filteredRxList = rxlist.array!.filter({$0["term"].stringValue.prefix(searchText.count) == searchText})
        searching = true
        //print("searchText \(searchText)")
        let stringg = searchText
        print(stringg)
        tblView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //print("searchText \(String(describing: searchBar.text))")
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        print(searchBar.text)
        searchBar.text = ""
        tblView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreinfo"{
            if let indexPath = tblView.indexPathForSelectedRow{
                
                let data: JSON
                if searching{//isFiltering(){
                    data = filteredRxList[indexPath.row]
                    
                }else{
                    data = rxlist[indexPath.row]
                    
                }
                let controller = segue.destination as? RxMedDetailsViewController
                //let temp = searchBar.text
                
                //print(searchBar.text)////////////
                
                //controller?.name2 = temp!//searchBar.text!
                let final = data["term"].stringValue
                controller?.name = final
                controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
            
        else{
            let controller = segue.destination as? RxMedDetailsViewController
            let temp = searchBar.text
            //print(searchBar.text)////////////
            controller?.name2 = temp!
        }
        
    }
    
    
    
    
    /*func searchBarIsEmpty() -> Bool{
     return searchController.searchBar.text?.isEmpty ?? true
     
     }
     
     func isFiltering() -> Bool{
     return searchController.isActive && !searchBarIsEmpty()
     }*/
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
