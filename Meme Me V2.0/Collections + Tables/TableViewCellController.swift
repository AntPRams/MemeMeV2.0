//
//  TableViewCellController.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 30/05/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class TableViewCellController: UITableViewCell {
    
    //Properties
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel:     UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    //Set the highlight color

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let backgroundView =             UIView()
        backgroundView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        selectedBackgroundView =         backgroundView

    }
    
    //Configure cell borders image and text
    
    func configureCell (with meme: Meme) {
     
        cellImageView.layer.cornerRadius =  5.0
        cellImageView.layer.borderWidth =   1
        cellImageView.layer.borderColor =   UIColor.black.cgColor
        cellImageView.layer.masksToBounds = true
        cellImageView.contentMode =         .scaleAspectFill
        
        self.cellImageView.image = meme.originalImage
        self.cellLabel.text =      "\(meme.topText) \(meme.bottomText)"
        
        
    }

}
