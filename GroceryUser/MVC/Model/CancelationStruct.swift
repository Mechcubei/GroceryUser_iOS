//
//  CancelationStruct.swift
//  GroceryUser
//
//  Created by osx on 05/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import Foundation

struct CancelationStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:[CancelationStruct2]
    
}
struct CancelationStruct2:Decodable {
    let id:Int?
    let comment:String?
}
