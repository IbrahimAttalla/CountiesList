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
    
    init(CountriesListRemoteService: CountriesListRemoteServiceProtocol) {
        self.remoteDataSource = CountriesListRemoteService
    }
    
    func getAllCountries() -> AnyPublisher<[Country], NetworkErrors> {
        remoteDataSource.fetchCountiesList()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
