//
//  SelectMerchantStruct.swift
//  GroceryUser
//
//  Created by osx on 02/11/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct SelectMerchantStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:[SelectMerchantStruct2]?
}

struct SelectMerchantStruct2:Decodable {
    let category_id,marchent_user_id:Int?
    let first_name,last_name,username:String?
    let image:String?
}
