//
//  TabBarController.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 08/06/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller1: TableViewCellController!
        let controller2: MemesCollectionViewController!

        transition(from: controller1, to: controller2, duration: <#T##TimeInterval#>, options: <#T##UIView.AnimationOptions#>, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
