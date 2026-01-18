//
//  CountriesListEndPoint.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation

enum CountriesListEndPoint: EndPoint {
    case fetchCountiesList
}

extension CountriesListEndPoint {
    var path: String {
        switch self {
        case .fetchCountiesList:
            return "/all"
        }
    }
    
    var queryParameters: [String : String?] {
        switch self {
        case .fetchCountiesList:
            return [
                "fields": "name,capital,currencies,cca2,flag"
            ]
        }
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var bodyParmaters: [String : Any?] {
        [:]
    }
}
