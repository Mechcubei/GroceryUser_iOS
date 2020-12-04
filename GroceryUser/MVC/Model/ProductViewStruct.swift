//
//  ProductViewStruct.swift
//  GroceryUser
//
//  Created by osx on 15/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct ProductViewStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:[ProductViewStruct2]
}

struct ProductViewStruct2:Decodable {
    let merchant_inventory_id,category_id,qty,price,marchent_user_id:Int?
    let weight_type,inventory_name,image,category_name,category_image:String?
}


