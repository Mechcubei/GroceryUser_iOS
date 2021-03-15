//
//  FilterProductStruct.swift
//  GroceryUser
//
//  Created by osx on 18/12/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

// MARK: - FilterProductStruct
struct FilterProductStruct: Codable {
    let statusCode: Int
    let message: String
    let has_data: Bool
    let data: [FilterProductStruct2]

}

// MARK: - FilterProductStruct2
struct FilterProductStruct2: Codable {
    let merchant_inventory_id: Int?
    let category_id: Int?
    let category_name: String?
    let grocery_inventory_id: Int?
    let inventory_name: String?
    let qty: Int?
    let image: String?
    let price: Int?
    let weight_type: String?
    let marchent_user_id: Int?
    let discount:Int?
}

