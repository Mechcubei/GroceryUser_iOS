//
//  OrderRequestStruct.swift
//  GroceryUser
//
//  Created by osx on 28/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
struct OrderRequestStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:OrderRequestStruct2?
}

struct OrderRequestStruct2:Decodable {
    let merchant_inventory_id:[String]?
}
