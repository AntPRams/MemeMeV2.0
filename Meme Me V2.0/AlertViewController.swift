//
//  AlertViewController.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 04/06/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    
    var updateCollectionCompletion: (() -> Void)?
    var updateAndSaveCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.layer.cornerRadius = 8
    }
    @IBAction func updateCollection(_ sender: Any) {
        updateCollectionCompletion?()
    }
    @IBAction func updateAndSave(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        updateAndSaveCompletion?()
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //This is a invisible button set in the view to replicate a UIAlert behavior
    @IBAction func invisibleDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
