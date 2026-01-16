//
//  CountryDTO.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

struct CountryDTO: Codable {
    let cca2: String
    let name: NameDTO?
    let capital: [String]?
    let currencies: [String: CurrencyDTO]?
    let flag: String?
    
    struct NameDTO: Codable {
        let common: String
    }
    
    struct CurrencyDTO: Codable {
        let name: String
        let symbol: String
    }
}
