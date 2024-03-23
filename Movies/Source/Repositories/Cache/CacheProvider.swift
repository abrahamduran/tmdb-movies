//
//  CacheProvider.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

enum CacheKey {
    case popularMovies(page: Int)
    case movieDetails(id: Int)

    var rawValue: String {
        switch self {
        case .popularMovies(let page):
            return "popular-movies-\(page)"
        case .movieDetails(let id):
            return "movie-details-\(id)"
        }
    }
}

protocol CacheProvider {
    func fetchCachedData(forKey key: CacheKey) throws -> Data
    func cacheData(_ data: Data, forKey key: CacheKey)
    func clearCache(forKey key: CacheKey)
}

final class UserDefaultsCacheProvider: CacheProvider {
    private let userDefaults: UserDefaults
    private let cacheDuration: TimeInterval // Cache validity duration

    init(userDefaults: UserDefaults = .standard, cacheDuration: TimeInterval = 604_800) { // Default cache duration of 1 week
        self.userDefaults = userDefaults
        self.cacheDuration = cacheDuration
    }

    func fetchCachedData(forKey key: CacheKey) throws -> Data {
        guard let cachedData = userDefaults.object(forKey: key.rawValue) as? Data else {
            throw AppError.dataNotFound
        }
        guard let cacheTimestamp = userDefaults.object(forKey: "\(key.rawValue)Timestamp") as? TimeInterval,
              Date().timeIntervalSince1970 - cacheTimestamp < cacheDuration else {
            throw AppError.invalidCache
        }
        return cachedData
    }

    func cacheData(_ data: Data, forKey key: CacheKey) {
        userDefaults.set(data, forKey: key.rawValue)
        userDefaults.set(Date().timeIntervalSince1970, forKey: "\(key.rawValue)Timestamp")
    }

    func clearCache(forKey key: CacheKey) {
        userDefaults.removeObject(forKey: key.rawValue)
        userDefaults.removeObject(forKey: "\(key.rawValue)Timestamp")
    }
}
