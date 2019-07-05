//
//  GlobalExtensions.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 30/05/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import Foundation
import UIKit

protocol Global {
    func setBackground (in view: UIView)
}

class GlobalPreferences: Global {
    func setBackground(in view: UIView) {
        var backgroundImageView: UIImageView
                backgroundImageView = UIImageView(
                    frame: CGRect(
                        x: 0,
                        y: 0,
                        width: view.frame.width,
                        height: view.frame.height)
                )
        
                backgroundImageView.image = UIImage(named: "background")
                backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.insertSubview(backgroundImageView, at: 0)
        
            }
    }
    
    
//    func setBackgroundImage(in view: UIView) {
//
//        var backgroundImageView: UIImageView
//        backgroundImageView = UIImageView(
//            frame: CGRect(
//                x: 0,
//                y: 0,
//                width: view.frame.width,
//                height: view.frame.height)
//        )
//
//        backgroundImageView.image = UIImage(named: "background")
//        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.insertSubview(backgroundImageView, at: 0)
//
//    }
    

