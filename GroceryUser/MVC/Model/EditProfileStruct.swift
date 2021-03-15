//
//  EditProfileStruct.swift
//  GroceryUser
//
//  Created by osx on 18/12/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct EditProfileStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:EditProfileStruct2
}
struct EditProfileStruct2:Decodable {
    
    let first_name,
    last_name,
    email,
    image,address:String?
    let user_id,phone,country_code:Int?
    
}
