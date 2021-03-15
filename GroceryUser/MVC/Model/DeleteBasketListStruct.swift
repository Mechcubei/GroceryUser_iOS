//
//  DeleteBasketListStruct.swift
//  GroceryUser
//
//  Created by osx on 18/02/21.
//  Copyright © 2021 osx. All rights reserved.
//

import Foundation

import Foundation

// MARK: - DeleteBasketListStruct
struct DeleteBasketListStruct: Codable {
    let statusCode: Int
    let message: String
    let hasData: Bool
    let data: DeleteBasketListStruct2

    enum CodingKeys: String, CodingKey {
        case statusCode, message
        case hasData = "has_data"
        case data
    }
}

// MARK: - DataClass
struct DeleteBasketListStruct2: Codable {
    let count: Int
}
