//
//  AppError.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

enum AppError: LocalizedError {
    case failedRequest
    case noNetworkConnection
    case invalidCache
    case dataNotFound

    var errorDescription: String? {
        switch self {
        case .failedRequest:
            return "Something went wrong"
        case .noNetworkConnection:
            return "You are not connected to the internet"
        case .invalidCache:
            return "Something went wrong"
        case .dataNotFound:
            return "Something went wrong"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .failedRequest:
            return "Please try again."
        case .noNetworkConnection:
            return "Please, check your internet settings."
        case .invalidCache:
            return "Please, get back online in order to refresh offline data."
        case .dataNotFound:
            return "We couldn't find the data you were requesting."
        }
    }
}
