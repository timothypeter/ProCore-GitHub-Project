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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SHOWDIFFVC"){
            var diffViewController: DiffViewController = segue.destination as! DiffViewController
            diffViewController.diffInfoAsJSON = self.diffInfoAsJSON
        }
    }
}
