//
//  CountriesListRemoteService.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation
import Combine

// MARK: - Countries List Remote Service Protocol
protocol CountriesListRemoteServiceProtocol {
    func fetchCountiesList() -> AnyPublisher<[CountryDTO], NetworkErrors>
}

// MARK: - Countries List Remote Service Implementation
class CountriesListRemoteService: CountriesListRemoteServiceProtocol {
    private let apiService: APIService<CountriesListEndPoint>
    
    init(apiService: APIService<CountriesListEndPoint> = APIService()) {
        self.apiService = apiService
    }
    
    func fetchCountiesList() -> AnyPublisher<[CountryDTO], NetworkErrors> {
        return apiService
            .sendRequest(to: .fetchCountiesList)
            .eraseToAnyPublisher()
    }
}
