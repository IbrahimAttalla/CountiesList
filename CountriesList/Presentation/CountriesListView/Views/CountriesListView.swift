//
//  CountriesListView.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import SwiftUI

struct CountriesListView: View {
    @ObservedObject var viewModel: CountriesListViewModel
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(
                searchText: $viewModel.searchText,
                isSearchFocused: $isSearchFocused,
                onSearch: {
                    viewModel.searchCountries()
                },
                onClear: {
                    viewModel.searchText = ""
                    viewModel.showFavoriteList()
                }
            )
            
            Divider()
            
            if viewModel.isSearching && viewModel.countries.isEmpty {
                EmptySearchView {
                    viewModel.showFavoriteList()
                }
            } else {
                SavedCountriesListView(
                    savedCountries: $viewModel.countries,
                    onRemove: viewModel.removeFromFavorites,
                    onNavigate: viewModel.navigateToCountryDetails,
                    onAddFavorite: viewModel.addToFavorites
                )
            }
        }
        .navigationTitle("Countries List")
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
            ),
            locationServices: LocationService()
        )
    )
}
