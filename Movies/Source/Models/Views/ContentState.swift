//
//  ContentState.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import Foundation

enum ContentState<T: Equatable>: Equatable {
    case loading
    case content(T)
    case error

    var model: T? {
        guard case .content(let t) = self else {
            return nil
        }
        return t
    }
}
