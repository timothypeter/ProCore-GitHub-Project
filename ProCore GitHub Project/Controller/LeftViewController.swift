//
//  LeftViewController.swift
//  ProCore GitHub Project
//
//  Created by Timothy Peter on 9/24/17.
//  Copyright © 2017 Timothy Peter. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class LeftViewController: UIViewController{
    
    @IBOutlet var textView: UITextView!
    var diffInfoAsJSON: JSON = JSON.null
    var diff: Diff = Diff(rawValue: "")
    
    override func viewDidLoad() {
        if(diffInfoAsJSON != JSON.null){
            self.textView.text = diffInfoAsJSON["diff_url"].stringValue
            
            let stringToUse: String = diffInfoAsJSON["diff_url"].stringValue
            
            let url = URL(string: stringToUse)
            
            let request = URLRequest(url: url!)
            
            Alamofire.request(stringToUse).responseJSON { response in
                
                print("Response: \(String(describing: response.response))")
                
                if let json = response.result.value{
                    print("JSON: \(json)")
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
                    print("Data: \(utf8Text)") //original server data as UTF8 string
                    //self.textView.text = utf8Text
                    
                    self.diff = Diff(rawValue: utf8Text);
                    
                    var stringForTextField: String = ""
                    
                    //I'm not proud of this, but for the sake of finishing in time this is here
                    for files in self.diff.files{
                        for hunk in files.hunks{
                            for leftLine in hunk.leftLines{
                                stringForTextField += "\(leftLine)\n"
                            }
                        }
                    }
                    
                    self.textView.text = stringForTextField
                }
            }
        }
    }
}

