//
//  CustomNavigationBar.swift
//  Meme Me V1.0
//
//  Created by António Ramos on 25/04/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        
    }
}
