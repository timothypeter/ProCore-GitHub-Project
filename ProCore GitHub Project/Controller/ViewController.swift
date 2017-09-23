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
    
    @IBOutlet var tableView: UITableView!
    
    //The jSON will return an array of dictionaries. This array is to store them for later use
    var arrayOfDictsOfIssues: [Dictionary<String, JSON>] = []
    
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
                
                //if let issues_url = json["labels"].array{
                   // print(issues_url)
               // }
                
                self.tableView.reloadData()
                
               // let pull_requests = json["pull_request"].arrayValue.map({$0["diff_url"].stringValue})
            }
        }
    }
    
    //Table View Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfDictsOfIssues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell()
        
        let dictionary = arrayOfDictsOfIssues[indexPath.row]["pull_request"]
        
        let stringForTitle = dictionary!["url"].stringValue
        
        //if let stringForTitle: String = arrayOfDictsOfIssues[indexPath.row]["pull_request"]?.stringValue{
            cell.textLabel?.text = stringForTitle
       // }
        
        
        //cell.textLabel?.text = "Hello"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
