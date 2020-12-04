//
//  Comman.swift
//  Covid
//
//  Created by osx on 13/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation



func createHeaders() -> String{
    
    print("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")")
    
    return  "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"
    
}
