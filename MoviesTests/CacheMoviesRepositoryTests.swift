//
//  CacheMoviesRepositoryTests.swift
//  MoviesTests
//
//  Created by Abraham Duran on 3/23/24.
//

import XCTest
@testable import Movies

final class CacheMoviesRepositoryTests: XCTestCase {
    func testFetchPopularMoviesFromCache() async {
        let mockCache = MockCacheProvider()
        let repository = CacheMoviesRepository(cache: mockCache)

        let sampleMovies = [Movie.mock()]
        let cachedData = try! JSONEncoder().encode(sampleMovies)
        mockCache.cacheData(cachedData, forKey: .popularMovies(page: 1))

        do {
            let movies = try await repository.fetchPopularMovies(page: 1)
            XCTAssertEqual(movies, sampleMovies)
        } catch {
            XCTFail("Fetching popular movies from cache should not fail")
        }
    }

    func testFetchMovieDetailsFromCache() async {
        let mockCache = MockCacheProvider()
        let repository = CacheMoviesRepository(cache: mockCache)

        let sampleMovieDetails = MovieDetails.mock()
        let cachedData = try! JSONEncoder().encode(sampleMovieDetails)
        mockCache.cacheData(cachedData, forKey: .movieDetails(id: 1))

        do {
            let details = try await repository.fetchMovieDetails(id: 1)
            XCTAssertEqual(details, sampleMovieDetails)
        } catch {
            XCTFail("Fetching movie details from cache should not fail")
        }
    }

    func testCacheMissingData() async {
        let mockCache = MockCacheProvider()
        mockCache.errorToThrow = AppError.dataNotFound
        mockCache.shouldThrowError = true
        let repository = CacheMoviesRepository(cache: mockCache)

        do {
            _ = try await repository.fetchPopularMovies(page: 1)
            XCTFail("Fetching movies should fail due to cache miss")
        } catch {
            // Expected failure due to cache missing data
            XCTAssertEqual(error as? AppError, AppError.dataNotFound)
        }
    }
}
