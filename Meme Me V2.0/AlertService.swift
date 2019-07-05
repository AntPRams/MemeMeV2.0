//
//  AlertService.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 05/06/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert(update: @escaping () -> Void, updateAndSave: @escaping () -> Void) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        
        alertVC.updateCollectionCompletion = update
        alertVC.updateAndSaveCompletion = updateAndSave
        
        return alertVC
    }
}
