//
//  NetworkErrors.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 16/01/2026.
//

import Foundation

enum NetworkErrors: Error {
    case badRequest
    case corruptedData
    case unAuthorized
    case notFound
    case parsingError
    case serverError
}
