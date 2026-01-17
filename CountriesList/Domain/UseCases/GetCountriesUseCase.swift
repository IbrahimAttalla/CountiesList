//
//  GetCountriesUseCase.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//
import Foundation
import Combine

class GetCountriesUseCase {
    private let repository: CountryRepositoryProtocol
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Country], NetworkErrors> {
        return repository.getAllCountries()
    }
}
