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
        
        Alamofire.request(Router.getPullRequests(parameters: dict))
    }
}
