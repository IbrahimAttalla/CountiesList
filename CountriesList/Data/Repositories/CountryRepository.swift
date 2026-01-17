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
        let isOnline = true

        if isOnline && !localDataSource.hasSavedData() {
            return remoteDataSource.fetchCountiesList()
                .map { $0.map { $0.toDomain() } }
                .eraseToAnyPublisher()
        } else {
            return Just(localDataSource.fetchSavedList())
                .setFailureType(to: NetworkErrors.self)
                .eraseToAnyPublisher()
        }
    }
    
}
