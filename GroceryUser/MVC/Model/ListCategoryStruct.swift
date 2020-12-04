//
//  ListCategoryStruct.swift
//  GroceryUser
//
//  Created by osx on 25/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct ListCategoryStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:[ListCategoryStruct2]?
}

struct ListCategoryStruct2:Decodable {
    let category_id,merchant_inventory_id,grocery_inventory_id,qty,price,marchent_user_id:Int?
    let category_name,first_name,last_name,username:String?
    let category_image:String?
    let inventory_name:String?
    let weight_type:String?
    let image:String?
    var selectedQty:Int? = 0
    var isSelected:Bool?

}