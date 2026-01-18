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

extension CountryDTO {
    func toDomain() -> Country {

        let countryName = name?.common ?? cca2
        
        let mappedCurrencies = currencies?.map { code, currencyDTO in
            Country.Currency(
                code: code,
                name: currencyDTO.name,
                symbol: currencyDTO.symbol
            )
        }
        
        return Country(
            id: cca2,
            name: countryName,
            capital: capital?.first,
            flag: flag,
            currencies: mappedCurrencies
        )
    }
}

