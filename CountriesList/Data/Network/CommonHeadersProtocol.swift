//
//  CommonHeadersProtocol.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//
import Foundation

public protocol CommonHeadersProtocol {
    var commonHeaders: [String: String] { get }
}

public extension CommonHeadersProtocol {
    var commonHeaders: [String: String] {
        var params = [String: String]()
        params["Content-Type"] = "application/json"
        params["Accept"] = "application/json"
        params["Authorization"] = "Bearer \(Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")"
        return params
    }
}
