//
//  FetchCountriesUseCase.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//
import Foundation
import Combine

protocol FetchCountriesUseCaseProtocol {
    var baseCountriesList: [Country] { get }
    var filteredCountriesPublisher: AnyPublisher<[Country], Never> { get }
    func execute() -> AnyPublisher<[Country], NetworkErrors>
    func fetchCountry(countryCode: String)
    func searchCountry(byName name: String)
    func addToFavorites(country: Country)
    func removeFromFavorites(country: Country)
    func getFavoriteList()
}

class FetchCountriesUseCase: FetchCountriesUseCaseProtocol {
    
    var baseCountriesList: [Country] = []
    
    private let filteredCountriesSubject = CurrentValueSubject<[Country], Never>([])
    
    var filteredCountriesPublisher: AnyPublisher<[Country], Never> {
        filteredCountriesSubject.eraseToAnyPublisher()
    }
    
    private let repository: CountryRepositoryProtocol
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Country], NetworkErrors> {
        return repository.getAllCountries()
            .map { [weak self] countries in
                self?.baseCountriesList = countries
                
                return countries
            }
            .eraseToAnyPublisher()
        
    }
    
    func fetchCountry(countryCode: String) {
        if let defaultCountry = baseCountriesList.first { $0.id == countryCode} {
            _ = repository.saveFavoriteCountry(defaultCountry)
            updateBaseCountriesList(defaultCountry.id, isFavorite: true)
            filteredCountriesSubject.send(repository.getFavoriteCountries())
        }
    }
    
    func searchCountry(byName name: String) {
        if name.isEmpty {
            filteredCountriesSubject.send(repository.getFavoriteCountries())
        } else {
            let filtered = baseCountriesList.search(by: name)
            filteredCountriesSubject.send(filtered)
        }
    }
    
    func addToFavorites(country: Country) {
        _ = repository.saveFavoriteCountry(country)
        updateBaseCountriesList(country.id, isFavorite: true)
        filteredCountriesSubject.send(repository.getFavoriteCountries())
    }
    
    func removeFromFavorites(country: Country) {
        _ = repository.deleteFavoriteCountry(country)
        updateBaseCountriesList(country.id, isFavorite: false)
        filteredCountriesSubject.send(repository.getFavoriteCountries())
    }
    
    func getFavoriteList() {
        filteredCountriesSubject.send(repository.getFavoriteCountries())
    }
    
    private func updateBaseCountriesList(_ id: String, isFavorite: Bool) {
        if let index = baseCountriesList.firstIndex(where: { $0.id == id }) {
            var updated = baseCountriesList[index]
            updated.isFavorite = isFavorite
            baseCountriesList[index] = updated
        }
    }
    
}
