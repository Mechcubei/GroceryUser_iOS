//
//  VerifiedOtpStruct.swift
//  GroceryUser
//
//  Created by osx on 28/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import Foundation

struct VerifiedOtpStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:[VerifiedOtpStruct2]?
}

struct VerifiedOtpStruct2:Decodable {
    let first_name:String?
    let last_name:String?
    let email:String?
    let id: Int?
    let otp: String?
    let verification_type:String?
}
