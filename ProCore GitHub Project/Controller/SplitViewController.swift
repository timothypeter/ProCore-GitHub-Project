//
//  DiffViewController.swift
//  ProCore GitHub Project
//
//  Created by Timothy Peter on 9/23/17.
//  Copyright © 2017 Timothy Peter. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class SplitViewController: UIViewController{
    
    var diffInfoAsJSON: JSON = JSON.null
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Do some work before we lead each of our segues that are inside the container views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SHOWDIFFVC"){
            let diffViewController: DiffViewController = segue.destination as! DiffViewController
            //set the diff info to load
            diffViewController.diffInfoAsJSON = self.diffInfoAsJSON
        }
        
        else
        {
            let leftViewController: LeftViewController = segue.destination as! LeftViewController
            //set the diff info to load
            leftViewController.diffInfoAsJSON = self.diffInfoAsJSON
        }
    }
}
