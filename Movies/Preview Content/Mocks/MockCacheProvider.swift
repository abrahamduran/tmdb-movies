//
//  MockCacheProvider.swift
//  Movies
//
//  Created by Abraham Duran on 3/23/24.
//

import Foundation

final class MockCacheProvider: CacheProvider {
    var cache: [String: Data] = [:]
    var shouldThrowError: Bool = false
    var errorToThrow: Error = AppError.dataNotFound

    func fetchCachedData(forKey key: CacheKey) throws -> Data {
        if shouldThrowError {
            throw errorToThrow
        }

        return cache[key.rawValue] ?? Data()
    }

    func cacheData(_ data: Data, forKey key: CacheKey) {
        cache[key.rawValue] = data
    }

    func clearCache(forKey key: CacheKey) {
        cache.removeValue(forKey: key.rawValue)
    }
}
