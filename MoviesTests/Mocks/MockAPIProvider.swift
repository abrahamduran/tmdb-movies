//
//  MockAPIProvider.swift
//  Movies
//
//  Created by Abraham Duran on 3/23/24.
//

import Foundation
@testable import Movies

final class MockAPIProvider: APIProvider {
    var data: Data?
    var shouldThrowError: Bool = false
    var errorToThrow: Error = URLError(.badServerResponse)

    func fetch(from url: URL, parameters: [URLQueryItem]?) async throws -> Data {
        if shouldThrowError {
            throw errorToThrow
        }
        return data ?? Data()
    }
}
