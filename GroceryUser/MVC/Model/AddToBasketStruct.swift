//
//  AddToBasketStruct.swift
//  GroceryUser
//
//  Created by osx on 21/12/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct AddToBasketStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:AddToBasketStruct2?
}

struct AddToBasketStruct2:Decodable {
    let count:Int?
}
