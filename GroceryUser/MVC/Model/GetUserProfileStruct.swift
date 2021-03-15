//
//  GetUserProfileStruct.swift
//  GroceryUser
//
//  Created by osx on 09/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct GetUserProfileStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:GetUserProfileStruct2
}

struct GetUserProfileStruct2:Decodable{
    let image,email,first_name,last_name,latitude,longitude,address:String?
    let user_id,phone,country_code:Int?
    let phone_status:Int?
    let email_status:Int?
}
