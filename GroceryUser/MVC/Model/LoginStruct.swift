//
//  LoginStruct.swift
//  GroceryUser
//
//  Created by osx on 30/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct LoginStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:LoginStruct2?
}
struct LoginStruct2:Decodable {
    
    let first_name,token,last_name,email,image:String?
    let id:Int?
    
}
