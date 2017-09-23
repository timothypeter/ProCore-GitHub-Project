//
//  ViewController.swift
//  grok101
//
//  Created by Timothy Peter on 2016-10-29.
//  Copyright © 2016 Teak Mobile Inc. All rights reserved.
//
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = [String: String]()
        
        //Testing the call to retrieve pull requests
        Alamofire.request(Router.getPullRequests(parameters: dict)).response {response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
                print("Data: \(utf8Text)")
            }
        }
    }
}
