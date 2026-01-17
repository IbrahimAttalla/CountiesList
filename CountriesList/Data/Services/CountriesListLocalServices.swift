//
//  CountriesListLocalServices.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation
import SwiftData

protocol CountriesListLocalServicesProtocol {
    func getFavorites() -> [Country]
    func saveFullList(_ countries: [Country]) -> Bool
    func fetchSavedList() -> [Country]
    func hasSavedData() -> Bool
    func addFavorite(_ country: Country) -> Bool
    func removeFavorite(_ country: Country)
    func isFavorite(_ country: Country) -> Bool
    func canAddMore() -> Bool
}

final class CountriesListLocalServices: CountriesListLocalServicesProtocol {
    
    private let maxFavorites = 5
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init() {
        let schema = Schema([SavedCountry.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func hasSavedData() -> Bool {
        return !fetchSavedList().isEmpty
    }
    
    func getFavorites() -> [Country] {
        let descriptor = FetchDescriptor<SavedCountry>(
            predicate: #Predicate { $0.isFavorite }
        )
        
        do {
            let savedCountries = try modelContext.fetch(descriptor)
            return savedCountries.map { $0.toCountry() }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    func saveFullList(_ countries: [Country]) -> Bool {
        countries.map {
            SavedCountry(
                id: $0.id,
                name: $0.name,
                capital: $0.capital,
                flag: $0.flag,
                currencies: $0.currencies
            )
        }
        .forEach{ modelContext.insert($0) }
        
        do {
            try modelContext.save()
            return true
        } catch {
            print("Error saving favorite: \(error)")
            return false
        }
        
    }
    
    func fetchSavedList() -> [Country] {
        let descriptor = FetchDescriptor<SavedCountry>()
        
        do {
            let savedCountries = try modelContext.fetch(descriptor)
            return savedCountries.map { $0.toCountry() }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
        
    }
    
    func addFavorite(_ country: Country) -> Bool {
        
        let allFavorites = getFavorites()
        if allFavorites.count >= maxFavorites {
            return false
        }
        
        let descriptor = FetchDescriptor<SavedCountry>(
            predicate: #Predicate { $0.id == country.id }
        )
        
        do {
            let savedCountry = try modelContext.fetch(descriptor)
            savedCountry.first?.isFavorite = true
            try modelContext.save()
            return true
            
        } catch {
            print("Error fetching favorites: \(error)")
            return false
        }
        
    }
    
    func removeFavorite(_ country: Country) {
        let descriptor = FetchDescriptor<SavedCountry>(
            predicate: #Predicate { $0.id == country.id }
        )
        
        do {
            let savedCountry = try modelContext.fetch(descriptor)
            savedCountry.first?.isFavorite = false
            try modelContext.save()
            
        } catch {
            print("Error fetching favorites: \(error)")
            
        }
    }
    
    func isFavorite(_ country: Country) -> Bool {
        let descriptor = FetchDescriptor<SavedCountry>(
            predicate: #Predicate { $0.id == country.id && $0.isFavorite }
        )
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            return !favorites.isEmpty
        } catch {
            print("Error checking if favorite: \(error)")
            return false
        }
    }
    
    func canAddMore() -> Bool {
        getFavorites().count < maxFavorites
    }
    
}
