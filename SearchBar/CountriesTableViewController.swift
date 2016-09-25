//
//  CountriesTableViewController.swift
//  SearchBar
//
//  Created by CS3714 on 9/25/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit





class CountriesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    
    /*
     
     We make the class conform to the UISearchResultsUpdating protocol so that we can
     
     implement its protocol method updateSearchResultsForSearchController, which updates
     
     the search results based on the search query entered by the user into the search bar.
     
     */
    
    
    
    // These two instance variables are used for Search Bar functionality
    
    var searchResults = [String]()
    
    var searchResultsController = UISearchController()
    
    
    
    // Object reference to the array to hold all of the country names
    
    var countryNames  = [String]()
    
    
    
    // Instance variable to hold the country name selected
    
    var countryNameSelected: String = ""
    
    
    
    /*
     
     -----------------------
     
     MARK: - View Life Cycle
     
     -----------------------
     
     */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        //========== Import country names from the plist file ==========
        
        
        
        // Obtain the file path to the plist file.
        
        let countriesFilePath: NSString? = Bundle.main.path(forResource: "countries", ofType: "plist") as NSString?
        
        
        
        // Instantiate an NSArray object and initialize it with the contents of the countries.plist file.
        
        let countryNamesFromFile: NSArray? = NSArray(contentsOfFile: countriesFilePath! as String)
        
        
        
        // Unwrap the optional array countryNamesFromFile
        
        if let countryNamesList = countryNamesFromFile {
            
            
            
            // Obtain the list of country names as an Array
            
            countryNames = countryNamesList as! Array
            
            
            
            // Sort the country names within itself in alphabetical order
            
            countryNames.sort { $0 < $1 }
            
            
            
        } else { // Unable to get the file from the main bundle (project folder)
            
            
            
            /*
             
             Create a UIAlertController object; dress it up with title, message, and preferred style;
             
             and store its object reference into local constant alertController
             
             */
            
            let alertController = UIAlertController(title: "Unable to Access the countries.plist file!",
                                                    
                                                    message: "The file does not reside in the application's main bundle (project folder)!",
                                                    
                                                    preferredStyle: .alert)
            
            
            
            // Create a UIAlertAction object and add it to the alert controller
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            
            
            // Present the alert controller
            
            present(alertController, animated: true, completion: nil)
            
            
            
            return
            
        }
        
        //========== End of importing country names from the plist file ==========
        
        
        
        // Create a Search Results Controller object for the Search Bar
        
        createSearchResultsController()
        
        
        
        // Reload the table view
        
        self.tableView.reloadData()
        
    }
    
    
    
    /*
     
     ---------------------------------------------
     
     MARK: - Creation of Search Results Controller
     
     ---------------------------------------------
     
     */
    
    func createSearchResultsController() {
        
        /*
         
         Instantiate a UISearchController object and store its object reference into local variable: controller.
         
         Setting the parameter searchResultsController to nil implies that the search results will be displayed
         
         in the same view used for searching (under the same UITableViewController object).
         
         */
        
        let controller = UISearchController(searchResultsController: nil)
        
        
        
        /*
         
         We use the same table view controller (self) to also display the search results. Therefore,
         
         set self to be the object responsible for listing and updating the search results.
         
         Note that we made self to conform to UISearchResultsUpdating protocol.
         
         */
        
        controller.searchResultsUpdater = self
        
        
        
        /*
         
         The property dimsBackgroundDuringPresentation determines if the underlying content is dimmed during
         
         presentation. We set this property to false since we are presenting the search results in the same
         
         view that is used for searching. The "false" option displays the search results without dimming.
         
         */
        
        controller.dimsBackgroundDuringPresentation = false
        
        
        
        // Resize the search bar object based on screen size and device orientation.
        
        controller.searchBar.sizeToFit()
        
        
        
        /***************************************************************************
         
         No need to create the search bar in the Interface Builder (storyboard file).
         
         The statement below creates it at runtime.
         
         ***************************************************************************/
        
        
        
        // Set the tableHeaderView's accessory view displayed above the table view to display the search bar.
        
        self.tableView.tableHeaderView = controller.searchBar
        
        
        
        /*
         
         Set self (Table View Controller) define the presentation context so that the Search Bar subview
         
         does not show up on top of the view (scene) displayed by a downstream view controller.
         
         */
        
        self.definesPresentationContext = true
        
        
        
        /*
         
         Set the object reference (controller) of the newly created and dressed up UISearchController
         
         object to be the value of the instance variable searchResultsController.
         
         */
        
        searchResultsController = controller
        
    }
    
    
    
    /*
     
     -----------------------------------------------
     
     MARK: - UISearchResultsUpdating Protocol Method
     
     -----------------------------------------------
     
     
     
     This UISearchResultsUpdating protocol required method is automatically called whenever the search
     
     bar becomes the first responder or changes are made to the text or scope of the search bar.
     
     You must perform all required filtering and updating operations inside this method.
     
     */
    
    func updateSearchResults(for searchController: UISearchController)
        
    {
        
        // Empty the searchResults array without keeping its capacity
        
        searchResults.removeAll(keepingCapacity: false)
        
        
        
        // Set searchPredicate to search for any character(s) the user enters into the search bar.
        
        // [c] indicates that the search is case insensitive.
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        
        
        // Obtain the country names that contain the character(s) the user types into the Search Bar.
        
        let listOfCountryNamesFound = (countryNames as NSArray).filtered(using: searchPredicate)
        
        
        
        // Obtain the search results as an array of type String
        
        searchResults = listOfCountryNamesFound as! [String]
        
        
        
        // Reload the table view to display the search results
        
        self.tableView.reloadData()
        
    }
    
    
    
    /*
     
     ----------------------------------------------
     
     MARK: - UITableViewDataSource Protocol Methods
     
     ----------------------------------------------
     
     */
    
    
    
    // Asks the data source to return the number of sections in the table view.
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        
        return 1  // We have only 1 section in our table view
        
    }
    
    
    
    // Asks the data source to return the number of rows in a given section of a table view.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        // Use the Ternary Conditional Operator to concisely represent the IF statement below.
        
        return searchResultsController.isActive ? searchResults.count : countryNames.count
        
        /*
         
         if (searchResultsController.isActive) {
         
         // The user is using the search bar: Use searchResults.
         
         return searchResults.count
         
         }
         
         else {
         
         // The user is NOT using the search bar: Use countryNames.
         
         return countryNames.count
         
         }
         
         */
        
    }
    
    
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // In the Interface Builder (storyboard file), set the table view cell's identifier attribute to "CountryCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        
        
        cell.textLabel?.text = searchResultsController.isActive ? searchResults[(indexPath as NSIndexPath).row] : countryNames[(indexPath as NSIndexPath).row]
        
        
        
        return cell
        
    }
    
    
    
    /*
     
     -------------------------------------------
     
     MARK: - UITableViewDelegate Protocol Method
     
     -------------------------------------------
     
     */
    
    
    
    // Informs the table view delegate that the specified row is selected.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        countryNameSelected = searchResultsController.isActive ? searchResults[(indexPath as NSIndexPath).row] : countryNames[(indexPath as NSIndexPath).row]
        
        
        
        performSegue(withIdentifier: "ShowCountryMap", sender: self)
        
    }
    
    
    
    /*
     
     -------------------------
     
     MARK: - Prepare For Segue
     
     -------------------------
     
     */
    
    
    
    // This method is called by the system whenever you invoke the method performSegue.
    
    // You never call this method. It is invoked by the system.
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        
        
        if segue.identifier == "ShowCountryMap" {
            
            
            
            // Obtain the object reference of the destination view controller
            
            let webViewController: WebViewController = segue.destination as! WebViewController
            
            
            
            // Pass the data object (selected country name) to the destination view controller object
            
            webViewController.selectedCountryName = countryNameSelected
            
        }
        
    }
    
}
