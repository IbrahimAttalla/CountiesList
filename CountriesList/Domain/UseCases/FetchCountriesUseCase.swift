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
            
            let itemAdded = repository.saveFavoriteCountry(defaultCountry)
            
            if itemAdded {
                filteredCountriesSubject.send(repository.getFavoriteCountries()) 
            }
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

}
