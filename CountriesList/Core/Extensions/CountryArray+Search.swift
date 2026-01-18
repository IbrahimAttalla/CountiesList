//
//  CountryArray+Search.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

extension Array where Element == Country {
    func search(by text: String) -> [Country] {
        let query = text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else { return self }
        
        return filter {
            $0.name.lowercased().contains(query) ||
            ($0.capital?.lowercased().contains(query) ?? false)
        }
    }
}
