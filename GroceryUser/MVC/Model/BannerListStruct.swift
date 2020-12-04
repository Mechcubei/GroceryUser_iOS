//
//  BannerListStruct.swift
//  GroceryUser
//
//  Created by osx on 09/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct BannerListStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:[BannerListStruct2]
}

struct BannerListStruct2:Decodable {
    let id:Int?
    let banner_image,status,created_at,updated_at:String?
}

