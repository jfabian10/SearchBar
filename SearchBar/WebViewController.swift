//
//  WebViewController.swift
//  SearchBar
//
//  Created by CS3714 on 9/25/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    // Instance variable holding the object reference of the Web View object.
    
    @IBOutlet var webView: UIWebView!
    
    
    
    // The value of this instance variable is set by the upstream view controller (TableViewController) object.
    
    var selectedCountryName: String = ""
    
    
    
    /*
     
     -----------------------
     
     MARK: - View Life Cycle
     
     -----------------------
     
     */
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Set this view's title to be the selected country name
        
        self.title = selectedCountryName
        
        
        
        /*
         
         We compose a Google Maps API query by using the selected country name.
         
         We ask the webView object to send the query to Google Maps API, obtain the map, and display it.
         
         The query cannot contain spaces. Therefore, we replace all spaces in a country name, if any, with "+".
         
         */
        
        let selectedCountryNameWithNoSpaces = selectedCountryName.replacingOccurrences(of: " ", with: "+", options: [], range: nil)
        
        
        
        /*
         
         Convert the Google Maps API query string into an NSURL object and store its object
         
         reference into the local variable url. An NSURL object represents a URL.
         
         */
        
        let url = URL(string: "https://www.google.com/maps/place/" + selectedCountryNameWithNoSpaces)
        
        
        
        /*
         
         Convert the NSURL object into an NSURLRequest object and store its object
         
         reference into the local variable request. An NSURLRequest object represents
         
         a URL load request in a manner independent of protocol and URL scheme.
         
         */
        
        let request = URLRequest(url: url!)
        
        
        
        // Ask the webView object to fetch and display the map of the selected country
        
        webView.loadRequest(request)
        
    }
    
    
    
    /*
     
     ----------------------------------
     
     MARK: - UIWebView Delegate Methods
     
     ----------------------------------
     
     */
    
    
    
    /**********************************************************************
     
     * These three methods must be implemented whenever UIWebView is used. *
     
     **********************************************************************/
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView!) {
        
        // Starting to load the web page. Show the animated activity indicator in the status bar
        
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView!) {
        
        // Finished loading the web page. Hide the activity indicator in the status bar.
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    
    
    func webView(_ webView: UIWebView!, didFailLoadWithError error: NSError!) {
        
        /*
         
         Ignore this error if the page is instantly redirected via JavaScript or in another way.
         
         NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
         
         when the page is instantly redirected via JavaScript or in another way.
         
         */
        
        if (error as NSError).code == NSURLErrorCancelled  {
            
            return
            
        }
        
        
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
        
        // Create an error message in HTML as a character string and store it into the local constant errorString
        
        let errorString = "<html><font size=+2 color='red'><p>An error occurred: <br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        
        
        // Display the error message within the UIWebView object
        
        self.webView.loadHTMLString(errorString, baseURL: nil)
        
    }
    
    
    
}
