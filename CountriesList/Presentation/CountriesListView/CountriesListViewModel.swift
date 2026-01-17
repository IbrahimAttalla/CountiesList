//
//  CountriesListViewModel.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import Foundation
import Combine

final class CountriesListViewModel: ObservableObject {
    
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let router: CountriesListRouter
    private let countriesUseCase: FetchCountriesUseCaseProtocol
    private let locationServices: LocationServiceProtocol
    
    init(router: CountriesListRouter,
         countriesUseCase: FetchCountriesUseCaseProtocol,
         locationServices: LocationServiceProtocol) {
        self.router = router
        self.countriesUseCase = countriesUseCase
        self.locationServices = locationServices
        bind()
    }
    
    // MARK: - Bind Publishers
    private func bind() {
        countriesUseCase.filteredCountriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countries in
                self?.countries = countries
                print("filtered Countries", countries)
            }
            .store(in: &cancellables)
    }
    
    func fetchCountries() {
        isLoading = true
        errorMessage = nil
        
        countriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] countries in
                self?.loadDefaultCountry()
                // TODO: get user location and set it's country first
            }
            .store(in: &cancellables)
    }
    
    private func loadDefaultCountry() {
        locationServices.getCurrentCountryCode()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {}
                }, receiveValue: { countryCode in
                    print("countryCode", countryCode)
                    self.countriesUseCase.fetchCountry(countryCode: countryCode)
                }
            )
        
            .store(in: &cancellables)
    }
    
    func searchCountries() {
        countriesUseCase.searchCountry(byName: searchText)
    }
    
    func didSelectMovie(_ selectedCountry: Country) {
        router.navigate(
            to: .details(country: selectedCountry)
        )
    }
}
