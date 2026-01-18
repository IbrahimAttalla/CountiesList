//
//  Untitled.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    associatedtype T: EndPoint
    func sendRequest<U: Codable>(to endpoint: T) -> AnyPublisher<U, NetworkErrors>
}

class APIService<T: EndPoint>: APIServiceProtocol {
    
    func sendRequest<U: Codable>(to endpoint: T) -> AnyPublisher<U, NetworkErrors> {

        guard let request = endpoint.urlRequest else {
            return Fail(error: NetworkErrors.badRequest)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in

                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        return data
                    case 401:
                        throw NetworkErrors.unAuthorized
                    case 404:
                        throw NetworkErrors.notFound
                    default:
                        throw NetworkErrors.serverError
                    }
                }
                return data
            }
            .decode(type: U.self, decoder: JSONDecoder())
            .mapError { error in

                if let networkError = error as? NetworkErrors {
                    return networkError
                } else {
                    return .serverError
                }
            }
            .eraseToAnyPublisher()
    }
}
