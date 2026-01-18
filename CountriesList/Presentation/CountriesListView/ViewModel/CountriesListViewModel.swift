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
    @Published var searchText: String = ""
    
    var isSearching: Bool {
            !searchText.isEmpty
        }
    
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
        fetchCountries()
    }
    
    // MARK: - Bind Publishers
    private func bind() {
        countriesUseCase.filteredCountriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countries in
                self?.countries = countries
            }
            .store(in: &cancellables)
    }
    
    func fetchCountries() {
        
        countriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure = completion {}
            } receiveValue: { [weak self] countries in
                self?.loadDefaultCountry()
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
                    self.countriesUseCase.fetchCountry(countryCode: countryCode)
                }
            )
        
            .store(in: &cancellables)
    }
    
    func searchCountries() {
        countriesUseCase.searchCountry(byName: searchText)
    }
    
    func removeFromFavorites(_ country: Country) {
        searchText = ""
        countriesUseCase.removeFromFavorites(country: country)
    }
    
    func addToFavorites(_ country: Country) {
        searchText = ""
        countriesUseCase.addToFavorites(country: country)
    }
    
    func showFavoriteList(){
        searchText = ""
        countriesUseCase.getFavoriteList()
    }
    
    func navigateToCountryDetails(_ country: Country) {
        router.navigate(
            to: .details(country: country)
        )
    }
    
}
