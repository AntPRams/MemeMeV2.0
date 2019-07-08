//
//  CheckMemeController.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 29/05/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class MemeDetailController: MemeMeController {
    
    //MARK: Properties
    
    var meme: Meme!
    
    @IBOutlet weak var topTextField:    UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageMemeView:   UIImageView!
    
    @IBOutlet weak var navBarTitle:   UINavigationItem!
    @IBOutlet weak var cancelButton:  UIBarButtonItem!
    @IBOutlet weak var editButton:    UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    //Constraints Outlets
    
    @IBOutlet weak var imageViewCenterYConstraint: NSLayoutConstraint! 
    @IBOutlet weak var imageViewWidth:             NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight:            NSLayoutConstraint!
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(font: meme.font)
        
        topTextField.text =    meme.topText
        bottomTextField.text = meme.bottomText
        imageMemeView.image =  meme.originalImage
        
        updateConstraintsToImage(image: imageMemeView.image!)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navBarTitle.title = "Meme Detail"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let image = imageMemeView.image else {return}
        DispatchQueue.main.async {
            self.updateConstraintsToImage(image: image)
        }
    }
    
    //MARK: Buttons
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditMemeController") as? EditMemeController else {return}
        
        controller.meme = meme
        
        controller.modalTransitionStyle = .flipHorizontal
        present(controller, animated: true, completion: nil)
        
    }
    
    //MARK: Methods
    
    func updateConstraintsToImage(image: UIImage) {
        
        let screenWidth =          UIScreen.main.bounds.size.width
        let screenHeight =         UIScreen.main.bounds.size.height
        let screenMaxLenght =      max(screenWidth, screenHeight)
        let navAndToolBarHeights = toolBar.frame.height + navigationBar.frame.height
        let viewWidth =            UIScreen.main.bounds.width
        let widthProportion =      viewWidth / image.size.width
        var viewHeight =           UIScreen.main.bounds.height
        var heightProportion =     viewHeight / image.size.height
        
        var paddingTotal: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let bottomPadding = view.safeAreaInsets.bottom
            let topPadding =    view.safeAreaInsets.top
            paddingTotal =      bottomPadding + topPadding
        }
        
        let extraHeight = UIApplication.shared.statusBarFrame.height + paddingTotal
        
        //move the center of the imageView based on the size of the screen
        
        if screenMaxLenght >= 812 && UIDevice.current.userInterfaceIdiom == .phone {
            self.imageViewCenterYConstraint.constant = -2
        } else {
            if image.size.width < image.size.height && UIDevice.current.orientation.isLandscape{
                imageViewCenterYConstraint.constant = -8
            } else {
                imageViewCenterYConstraint.constant = 0
            }
        }
        let barsHeight: CGFloat = navAndToolBarHeights + extraHeight
        
        if UIDevice.current.orientation.isPortrait {
            
            if widthProportion < heightProportion {
                //adjust imageView by width
                imageViewWidth.constant =  viewWidth
                imageViewHeight.constant = image.size.height * widthProportion
                
            } else {
                // adjust imageView by height
                imageViewHeight.constant = viewHeight
                imageViewWidth.constant =  image.size.width * heightProportion
            }
        } else {
            
            viewHeight = UIScreen.main.bounds.height - barsHeight
            heightProportion = viewHeight / image.size.height
            
            if widthProportion < heightProportion {
                //adjust imageView by width
                imageViewWidth.constant =  viewWidth
                imageViewHeight.constant = image.size.height * widthProportion
                
            } else {
                // adjust imageView by height
                imageViewHeight.constant = viewHeight
                imageViewWidth.constant =  image.size.width * heightProportion
            }
        }
    }
}

extension MemeDetailController: UITextFieldDelegate {
    
    func initTextField(_ textField : UITextField, attribute : [NSAttributedString.Key : Any], userIteraction: Bool) {
        
        textField.delegate =                 self
        textField.defaultTextAttributes =    attribute
        textField.isUserInteractionEnabled = false
    }

    
    func setupTextField(font: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .strokeColor :     UIColor.black,
            .strokeWidth :     -4,
            .font: UIFont(name: font,
                          size: 40)!,
            .paragraphStyle:    paragraphStyle
        ]
        
        initTextField(topTextField, attribute: attributes, userIteraction: false)
        initTextField(bottomTextField, attribute: attributes, userIteraction: false)
    }
}


