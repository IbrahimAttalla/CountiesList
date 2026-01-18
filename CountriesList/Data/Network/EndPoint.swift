//
//  EndPoint.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation

protocol EndPoint: CommonHeadersProtocol {
    var baseUrl: String { get }

    var path: String { get }

    var queryParameters: [String: String?] { get }

    var headers: [String: String] { get }

    var method: RequestHTTPMethod { get }

    var bodyParmaters: [String: Any?] { get }
}

extension EndPoint {
    var baseUrl: String {
        "https://restcountries.com/v3.1"
    }
    
    var method: RequestHTTPMethod {
        .get
    }

    var urlRequest: URLRequest? {
        guard var url = URL(string: baseUrl + path) else { return nil }
        addQueryParametersToURL(url: &url)
        var request = createURLRequest(using: url)
        addHeadersToRequest(&request)
        addBodyParametersToURLRequest(&request)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
    
    /// Add Query Parameters to the URL
    private func addQueryParametersToURL(url: inout URL) {
        var queryParamters = [URLQueryItem]()
        for parameter in queryParameters {
            if let value = parameter.value {
                queryParamters.append(URLQueryItem(name: parameter.key, value: value))
            }
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryParamters
        guard let containedURL = urlComponents?.url else { return }
        url = containedURL
    }
    
    /// Create URLReuqest instance using previously created URL
    private func createURLRequest(using url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    /// Add headers to URLRequest
    private func addHeadersToRequest(_ request: inout URLRequest) {
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        for header in commonHeaders {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
    
    /// Add body parameters to URLRequest
    private func addBodyParametersToURLRequest(_ request: inout URLRequest) {
        guard !bodyParmaters.isEmpty else { return }
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParmaters, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}
