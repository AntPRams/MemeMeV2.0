//
//  CollectionViewCellController.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 29/05/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class CollectionViewCellController: UICollectionViewCell {
    
    //Properties
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTopText: UITextField!
    @IBOutlet weak var cellBottomText: UITextField!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    //Check if the cell is being edited
    
    var isEditing: Bool = false {
        didSet {
            checkedImageView.image = UIImage(named: "uncheckedShape")
            checkedImageView.isHidden = !isEditing
        }
    }
    
    //Change the image if selected
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                checkedImageView.image = isSelected ? UIImage(named: "checkedShape") : UIImage(named: "uncheckedShape")
            }
        }
    }
    
    //Configure cell borders image and text
    
    func configureCell (with meme: Meme) {
        
        setupTextField(font: meme.font)
        
        cellImageView.image = meme.originalImage
        cellTopText.text =    meme.topText
        cellBottomText.text = meme.bottomText
        
        cellImageView.layer.cornerRadius =  5.0
        cellImageView.layer.borderWidth =   1
        cellImageView.layer.borderColor =   UIColor.black.cgColor
        cellImageView.layer.masksToBounds = true
        cellImageView.contentMode =         .scaleAspectFill
    }
}

//MARK: TextField Delegate

extension CollectionViewCellController: UITextFieldDelegate {
    
    func initTextField(_ textField : UITextField, attribute : [NSAttributedString.Key : Any]) {
        
        textField.delegate = self
        
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
                          size: 16)!,
            .paragraphStyle:    paragraphStyle
        ]
        
        initTextField(cellTopText, attribute: attributes)
        initTextField(cellBottomText, attribute: attributes)
        
    }
    
}
