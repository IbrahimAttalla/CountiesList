//
//  CountriesListView.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import SwiftUI

struct CountriesListView: View {
    @StateObject private var viewModel: CountriesListViewModel
    
    init(viewModel: CountriesListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        Text("Countries List View")
            .onAppear {
                viewModel.fetchCountries()
            }
    }
    
}

#Preview {
    CountriesListView(
        viewModel: CountriesListViewModel(
            router: CountriesListRouter(),
            countriesUseCase: FetchCountriesUseCase(
                repository: CountryRepository(
                    countriesListRemoteService: CountriesListRemoteService(),
                    countriesListLocalServices: CountriesListLocalServices()
                )
            )
        )
    )
}
