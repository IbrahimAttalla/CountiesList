//
//  CountriesListRouter.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import SwiftUI

final class CountriesListRouter {
    
    private weak var navigationController: UINavigationController?

    enum Route: Hashable {
        case details(country: Country)
    }

    static func createModule(
        navigationController: UINavigationController
    ) -> UIViewController {

        let router = CountriesListRouter()
        
        let remoteService: CountriesListRemoteServiceProtocol = CountriesListRemoteService()
        let localService: CountriesListLocalServicesProtocol = CountriesListLocalServices()
        
        let countriesRepository: CountryRepositoryProtocol = CountryRepository(
            countriesListRemoteService: remoteService,
            countriesListLocalServices: localService
        )
        
        let countriesUseCase: FetchCountriesUseCaseProtocol = FetchCountriesUseCase(repository: countriesRepository)
        
        let viewModel = CountriesListViewModel(router: router, countriesUseCase: countriesUseCase)

        let view = CountriesListView(viewModel: viewModel)

        let hostingVC = UIHostingController(rootView: view)

        return hostingVC
    }

    func navigate(to route: Route) {
        switch route {
        case let .details(country):
           // TODO: navigate to details view through CountryDetails Router
            let countryDetailsView = UIHostingController(rootView: CountryDetailsView())
            navigationController?.pushViewController(countryDetailsView, animated: true)
        }
    }

}

