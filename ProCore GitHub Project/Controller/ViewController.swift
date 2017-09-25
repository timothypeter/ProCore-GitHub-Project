//
//  ViewController.swift
//  grok101
//
//  Created by Timothy Peter on 2016-10-29.
//  Copyright © 2016 Timothy Peter. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Create an outlet for the TableView
    @IBOutlet var tableView: UITableView!
    
    //The jSON will return an array of dictionaries. This array is to store them for later use
    var arrayOfDictsOfIssues: [Dictionary<String, JSON>] = []
    var jsonDictionaryWithDiff: JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Makes us only look for open issues/pull requests
        let dict = ["state" : "open"]
        
        var json: JSON = JSON.null
        
        //Testing the call to retrieve pull requests
        Alamofire.request(Router.getPullRequests(parameters: dict)).response {response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            //Print Data from response
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
               // print("Data: \(utf8Text)")
                
                json = JSON(data: data)
                
                for Dictionary in json
                {
                    
                    if let dictionary = Dictionary.1.dictionary
                    {
                        if(dictionary["pull_request"] != nil)
                        {
                            print(dictionary as Any)
                           self.arrayOfDictsOfIssues.append(dictionary)
                        }
                    }
                }
                
                print(json)
                
                self.tableView.reloadData()
            }
        }
    }
    
    //Table View Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfDictsOfIssues.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell()
        
        if let dictionary = arrayOfDictsOfIssues[indexPath.row]["pull_request"]
        {
            let prNumber = dictionary["url"].stringValue
            
            self.jsonDictionaryWithDiff = dictionary
            
            let titleString = arrayOfDictsOfIssues[indexPath.row]["title"]?.stringValue
            
            if let range = prNumber.range(of: "pulls/"){
                //TODO: Replace with Swift 4 equivalent
                let newString = prNumber.substring(from: range.upperBound)
                cell.textLabel?.text = titleString! + " - " + newString
                cell.textLabel?.numberOfLines = 0
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PUSHDIFFVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "PUSHDIFFVC"){
            let splitViewController: SplitViewController = segue.destination as! SplitViewController
            splitViewController.diffInfoAsJSON = self.jsonDictionaryWithDiff
        }
    }
}
