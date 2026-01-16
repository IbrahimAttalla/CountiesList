//
//  CountryRepositoryProtocol.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Combine

protocol CountryRepositoryProtocol {
    func getAllCountries() -> AnyPublisher<[Country], NetworkErrors>
}
