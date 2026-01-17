//
//  CountryRepository.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation
import Combine

final class CountryRepository: CountryRepositoryProtocol {
    
    private let remoteDataSource: CountriesListRemoteServiceProtocol
    private let localDataSource: CountriesListLocalServicesProtocol
    
    init(countriesListRemoteService: CountriesListRemoteServiceProtocol,
         countriesListLocalServices: CountriesListLocalServicesProtocol ) {
        remoteDataSource = countriesListRemoteService
        localDataSource = countriesListLocalServices
    }
    
    func getAllCountries() -> AnyPublisher<[Country], NetworkErrors> {
        
        if !localDataSource.hasSavedData() {
            return remoteDataSource.fetchCountiesList()
                .map { [weak self] remoteCountries in
                    let countries = remoteCountries.map { $0.toDomain() }
                    _ = self?.localDataSource.saveFullList(countries)
                    
                    return countries
                }
                .mapError { error in
                    return error
                }
                .eraseToAnyPublisher()
        } else {
            return Just(localDataSource.fetchSavedList())
                .setFailureType(to: NetworkErrors.self)
                .eraseToAnyPublisher()
        }
    }
    
    func saveFavoriteCountry(_ country: Country) -> Bool {
        localDataSource.addFavorite(country)
    }
    
    func getFavoriteCountries() -> [Country] {
        localDataSource.getFavorites()
    }
    

    
}
