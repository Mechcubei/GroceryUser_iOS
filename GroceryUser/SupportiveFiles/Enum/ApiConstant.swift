//
//  ApiConstant.swift
//  Covid
//
//  Created by osx on 10/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

//Mark:- Api's Url


enum ServerType{
    case dev
    case live
}

let server:ServerType = .dev

internal struct ApiBasePath{
    static var baseUrl:String{
        get {
            switch server {
            case .dev: return "http://134.209.157.211/Covid19/public/api/"
            case .live: return "http://134.209.157.211/Covid19/public/api/"
            }
        }
    }
}


enum ApiConstant:String{
    
    case signup
    case login
    case totalstats
    case dailystats
    case getprofile
    case allcountrywise
    case barchart
  
    
    
    func getUrl() -> String {
        switch self {
        case .signup: return ApiBasePath.baseUrl + "user-registration"
        case .login: return ApiBasePath.baseUrl + "login"
        case .totalstats: return ApiBasePath.baseUrl + "totalstats"
        case .dailystats: return ApiBasePath.baseUrl + "dailystats"
        case .getprofile: return ApiBasePath.baseUrl + "getprofile"
        case .allcountrywise: return ApiBasePath.baseUrl + "allcountrywise"
        case .barchart: return ApiBasePath.baseUrl + "bar-chart"
            
        }
    }
}
