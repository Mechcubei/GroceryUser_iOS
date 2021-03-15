//
//  BasketListStruct.swift
//  GroceryUser
//
//  Created by osx on 21/12/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

// MARK: - BasketListStruct
struct BasketListStruct: Codable {
    let statusCode: Int
    let message: String
    let hasData: Bool
    let data: [BasketListStruct2]

    enum CodingKeys: String, CodingKey {
        case statusCode, message
        case hasData = "has_data"
        case data
    }
}

// MARK: - Datum
struct BasketListStruct2: Codable {
    let merchantInventoryID, categoryID, groceryInventoryID, qty: Int
    let price: Int
    let weightType: String
    let marchentUserID: Int
    let inventoryName: String
    let image: String
    let categoryName: String
    let categoryImage: String
    let quantity: Int
    let basketID: Int
    var selectedQty:Int? = 0
    var isSelected:Bool?

    enum CodingKeys: String, CodingKey {
        case merchantInventoryID = "merchant_inventory_id"
        case categoryID = "category_id"
        case groceryInventoryID = "grocery_inventory_id"
        case qty, price
        case weightType = "weight_type"
        case marchentUserID = "marchent_user_id"
        case inventoryName = "inventory_name"
        case image
        case categoryName = "category_name"
        case categoryImage = "category_image"
        case quantity
        case basketID = "basket_id"
    }
}
