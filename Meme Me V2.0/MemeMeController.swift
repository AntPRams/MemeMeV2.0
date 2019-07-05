//
//  GlobalPreferences.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 30/05/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

//Since all the controllers are using the same background and the same transparency in the nav bar, i decided to encapsulate this methods and set this controller as the MemeMeController. Also, for those who use the keyboard, now the user can hide the keyboard if taps outside of his frame

class MemeMeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setBackgroundImage()
        
        if let navController = navigationController {
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setBackgroundImage() {
        
        let backgroundImageView: UIImageView
        backgroundImageView = UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.frame.width,
                height: self.view.frame.height)
        )
        
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundImageView, at: 0)
    }
}

