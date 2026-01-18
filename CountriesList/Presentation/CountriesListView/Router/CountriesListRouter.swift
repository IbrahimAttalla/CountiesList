//
//  CountriesListRouter.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import SwiftUI

final class CountriesListRouter {
    
    private weak var viewController: UIViewController?
    
    enum Route: Hashable {
        case details(country: Country)
    }

    static func createModule() -> UIViewController {

        let router = CountriesListRouter()
        
        let remoteService: CountriesListRemoteServiceProtocol = CountriesListRemoteService()
        let localService: CountriesListLocalServicesProtocol = CountriesListLocalServices()
        
        let countriesRepository: CountryRepositoryProtocol = CountryRepository(
            countriesListRemoteService: remoteService,
            countriesListLocalServices: localService
        )
       
        let locationService: LocationServiceProtocol = LocationService()

        let countriesUseCase: FetchCountriesUseCaseProtocol = FetchCountriesUseCase(
            repository: countriesRepository
        )
        
        let viewModel = CountriesListViewModel(
            router: router,
            countriesUseCase: countriesUseCase,
            locationServices: locationService
        )

        let view = CountriesListView(viewModel: viewModel)

        let hostingVC = UIHostingController(rootView: view)
        router.viewController = hostingVC
        
        return hostingVC
    }

    func navigate(to route: Route) {
        switch route {
        case let .details(country):
            let countryDetailsView = UIHostingController(rootView: CountryDetailsView(country: country))
            viewController?.navigationController?.pushViewController(countryDetailsView, animated: true)
        }
    }

}

