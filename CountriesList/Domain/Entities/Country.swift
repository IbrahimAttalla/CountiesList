//
//  Country.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

struct Country: Codable {
    let id: String
    let name: String
    let capital: String?
    let flag: String?
    let currencies: [Currency]?
    var isFavorite: Bool = false
    
    struct Currency: Codable {
        let code: String
        let name: String
        let symbol: String
    }
}
