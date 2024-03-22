//
//  UserError.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

//  return "Something went wrong"
//}
//}
//
//var recoverySuggestion: String? {
//switch self {
//case .someError:
//  return "Please try again."
    
enum UserError: LocalizedError {
    case failedRequest
    case noNetworkConnection

    var errorDescription: String? {
        switch self {
        case .failedRequest:
            return "Something went wrong"
        case .noNetworkConnection:
            return "You are not connected to the internet"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .failedRequest:
            return "Please try again."
        case .noNetworkConnection:
            return "Please, check your internet settings."
        }
    }
}
