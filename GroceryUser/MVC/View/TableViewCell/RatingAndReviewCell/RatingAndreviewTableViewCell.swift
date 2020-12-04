//
//  RatingAndreviewTableViewCell.swift
//  GroceryUser
//
//  Created by osx on 29/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class RatingAndreviewTableViewCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgProfile.cornerRadius = (self.imageView?.frame.size.width)!/2
  
    }
    
}
