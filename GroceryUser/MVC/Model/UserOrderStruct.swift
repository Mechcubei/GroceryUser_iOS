//
//  UserOrderStruct.swift
//  GroceryUser
//
//  Created by osx on 04/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import Foundation

struct UserOrderStruct:Decodable {
    let statusCode: Int?
    let message: String?
    let hasData: Bool?
    let data: [UserOrderStruct2]
}

struct UserOrderStruct2:Decodable {
    let id, userID, driverID, couponID: Int?
    let order_number: String?
    let address_id,delivery_charge, assigned_grocery: Int?
    let status, payment_type: String?
    let gst, total,subTotal: Double?
    let order_type, created_at: String?
    let updated_at: String?
    let req_items: [RequestItem]?
    let req_items_img: [RequestItemImg]?
}

// MARK: - ReqItem
struct RequestItem: Codable {
    let request_id, assigned_grocery, inventory_id: Int?
    let price,quantity: Double?

}

// MARK: - ReqItem
struct RequestItemImg: Codable {

}

