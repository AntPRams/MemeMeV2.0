//
//  DeviceDetectionStruct.swift
//  Meme Me V1.0
//
//  Created by António Ramos on 08/05/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import Foundation
import UIKit

struct Device {
    
    static let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLenght = max(screenWidth, screenHeight)
    
    //detect iphone screen size
    
    static let isIphone4less = isIphone && screenMaxLenght  < 568
    static let isIphone5 = isIphone && screenMaxLenght == 568
    static let isIphone6to8 = isIphone && screenMaxLenght == 667
    static let isIphone6Pto8P = isIphone && screenMaxLenght == 736
    static let isIphoneX  = isIphone && screenMaxLenght == 812
    static let isIphoneMax = isIphone && screenMaxLenght == 896
    
    //detect ipad screen size
    
    static let isIpadPro = isIpad && screenMaxLenght == 1024
    static let isIpadPro105 = isIpad && screenMaxLenght == 1112
    static let isIpadPro129 = isIpad && screenMaxLenght == 1366
    
}
//if UIDevice.current.orientation.isPortrait {
//    if imageHeight < imageWidth {
//        self.topTextFieldTopConstraint.constant = 230
//        self.bottomTextFieldBottomConstraint.constant = -230
//        self.imageMemeView.updateConstraintsIfNeeded()
//        
//    } else if imageHeight > imageWidth {
//        self.topTextFieldTopConstraint.constant = 70
//        self.bottomTextFieldBottomConstraint.constant = -70
//        self.imageMemeView.updateConstraintsIfNeeded()
//    }
//} else {
//    self.topTextFieldTopConstraint.constant = 20
//    self.bottomTextFieldBottomConstraint.constant = -20
//    self.imageMemeView.updateConstraintsIfNeeded()
//}
//
