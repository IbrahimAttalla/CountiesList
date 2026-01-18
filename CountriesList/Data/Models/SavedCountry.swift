//
//  SavedCountry.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation
import SwiftData

@Model
final class SavedCountry {
    @Attribute(.unique) var id: String
    var name: String
    var capital: String?
    var flag: String?
    var currenciesData: Data?
    var isFavorite: Bool = false
    
    init(id: String, name: String, capital: String?, flag: String?, currencies: [Country.Currency]?) {
        self.id = id
        self.name = name
        self.capital = capital
        self.flag = flag
        
        if let currencies = currencies,
           let data = try? JSONEncoder().encode(currencies) {
            self.currenciesData = data
        } else {
            self.currenciesData = nil
        }
    }
    
    func toCountry() -> Country {
        var currencies: [Country.Currency]? = nil
        if let data = currenciesData,
           let decoded = try? JSONDecoder().decode([Country.Currency].self, from: data) {
            currencies = decoded
        }
        
        return Country(
            id: id,
            name: name,
            capital: capital,
            flag: flag,
            currencies: currencies,
            isFavorite: isFavorite
        )
    }
}
