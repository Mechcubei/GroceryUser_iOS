//
//  GetUserOrderStruct.swift
//  GroceryUser
//
//  Created by osx on 30/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

//struct GetUserOrderStruct:Decodable {
//    let statusCode:Int?
//    let message:String?
//    let has_data:Bool?
//    let data:[GetUserOrderStruct2]
//}
//
//struct GetUserOrderStruct2:Decodable {
//
//    let id:Int?
//    let user_id:Int?
//    let driver_id:Int?
//    let coupon_id:Int?
//    let  address_id:Int?
//    let  sub_total:Int?
//    let  delivery_charge:Int?
//    let assigned_grocery:Int?
//    let inventory_id:Int?
//    let  quantity:Int?
//    let  req_items:[GetUserOrderStruct3]
//
//    let gst:Double?
//    let total:Double?
//
//    let order_number:String?
//    let status:String?
//    let payment_type:String?
//    let order_type:String?
//    let created_at:String?
//    let updated_at:String?
//    let req_items_img:[GetUserOrderStruct4]
//
//}
//
//struct GetUserOrderStruct3:Decodable {
//    let request_id:Int?
//    let assigned_grocery:Int?
//    let inventory_id:Int?
//    let quantity:Int?
//    let price:Int?
//
//}
//
//struct GetUserOrderStruct4:Decodable {
//    let request_id_img,image_status:Int?
//    let gro_image:String?
//}



// MARK: - GetUserOrderStruct
struct GetUserOrderStruct: Codable {
    let statusCode: Int
    let message: String
    let hasData: Bool
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case statusCode, message
        case hasData = "has_data"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
//    let id, userID, driverID, couponID: Int
//    let orderNumber: String
//    let addressID, subTotal, deliveryCharge, assignedGrocery: Int
//    let status, paymentType: PaymentType
//    let gst, total: Double
//    let orderType: OrderType
//    let createdAt: String
//    let updatedAt: String?
//    let reqItems: [ReqItem]
//    let reqItemsImg: [ReqItemsImg]

//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case driverID = "driver_id"
//        case couponID = "coupon_id"
//        case orderNumber = "order_number"
//        case addressID = "address_id"
//        case subTotal = "sub_total"
//        case deliveryCharge = "delivery_charge"
//        case assignedGrocery = "assigned_grocery"
//        case status
//        case paymentType = "payment_type"
//        case gst, total
//        case orderType = "order_type"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case reqItems = "req_items"
//        case reqItemsImg = "req_items_img"
    }
//}
//
//enum OrderType: String, Codable {
//    case groceryImage = "grocery_image"
//    case product = "product"
//}
//
//enum PaymentType: String, Codable {
//    case accepted = "accepted"
//    case pending = "pending"
//}

// MARK: - ReqItem
struct ReqItem: Codable {
//    let requestID, assignedGrocery, inventoryID, quantity: Int
//    let price: Int
//
//    enum CodingKeys: String, CodingKey {
//        case requestID = "request_id"
//        case assignedGrocery = "assigned_grocery"
//        case inventoryID = "inventory_id"
//        case quantity, price
//    }
}

// MARK: - ReqItemsImg
struct ReqItemsImg: Codable {
//    let requestIDImg: Int
//    let groImage: String
//    let imageStatus: String
//
//    enum CodingKeys: String, CodingKey {
//        case requestIDImg = "request_id_img"
//        case groImage = "gro_image"
//        case imageStatus = "image_status"
//    }
}
