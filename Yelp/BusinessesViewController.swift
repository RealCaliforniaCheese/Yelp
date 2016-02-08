//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.sizeToFit()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120 // ballpark in event of 1000's of data / teeny tiny scroll bar
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.filteredBusinesses = businesses
            // Simulator blank screen = after data comes back, need tableView to update itself
            self.tableView.reloadData()
            
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//        tableView.reloadData()
//    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton (true, animated: true)
        
        if let searchText = searchBar.text {
            filteredBusinesses = searchText.isEmpty ? businesses : businesses?.filter({(dataString:Business) -> Bool in dataString.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            });
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        print("editing")
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    
    // dataSource - how many rows and what views for each row
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            print("filteredBusinesses!.count")
            return filteredBusinesses!.count
        }
        else {
            print("filtered business nil")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        // Pass the selected object to the new view controller.
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters
        filters: [String : AnyObject]) {
        
        var categories = filters["categories"] as? [String]
            
            Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {
                (businesses:[Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.filteredBusinesses = businesses
                self.tableView.reloadData()
            }
    }
}
