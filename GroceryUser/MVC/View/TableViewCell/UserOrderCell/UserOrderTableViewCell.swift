//
//  UserOrderTableViewCell.swift
//  GroceryUser
//
//  Created by osx on 04/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import UIKit

class UserOrderTableViewCell: UITableViewCell {

    @IBOutlet var lblOrderId: UILabel!
    @IBOutlet var lblOrderNo: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblCreatedAt: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblPending: UILabel!
    @IBOutlet var imgPro: UIImageView!
    @IBOutlet var imgStatus: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
}
