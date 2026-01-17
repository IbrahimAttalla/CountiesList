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
    
    private var cancellable = Set<AnyCancellable>()
    
    private let router: CountriesListRouter
    private let countriesUseCase: FetchCountriesUseCaseProtocol
    
    init(router: CountriesListRouter,
         countriesUseCase: FetchCountriesUseCaseProtocol) {
        self.router = router
        self.countriesUseCase = countriesUseCase
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
                self?.countries = countries
            }
            .store(in: &cancellable)
    }
    
    func didSelectMovie(_ selectedCountry: Country) {
        router.navigate(
            to: .details(country: selectedCountry)
        )
    }
}
