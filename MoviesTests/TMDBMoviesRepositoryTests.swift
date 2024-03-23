//
//  TMDBMoviesRepositoryTests.swift
//  MoviesTests
//
//  Created by Abraham Duran on 3/23/24.
//

import XCTest
@testable import Movies

final class TMDBMoviesRepositoryTests: XCTestCase {
    func testFetchPopularMoviesSuccess() async {
        let api = MockAPIProvider()
        api.data = moviesData

        let repository = TMDBMoviesRepository(api: api, cache: MockCacheProvider())

        do {
            let movies = try await repository.fetchPopularMovies(page: 1)
            XCTAssertFalse(movies.isEmpty, "Movies should be fetched successfully.")
            XCTAssertEqual(movies.first?.id, 1011985)
            XCTAssertEqual(movies.first?.title, "Kung Fu Panda 4")
            XCTAssertNotNil(movies.first?.posterPath)
        } catch {
            XCTFail("Fetching movies failed when it should have succeeded.")
        }
    }

    func testFetchMovieDetailsSuccess() async {
        let api = MockAPIProvider()
        api.data = movieDetailsData

        let repository = TMDBMoviesRepository(api: api, cache: MockCacheProvider())

        do {
            let details = try await repository.fetchMovieDetails(id: 1)
            XCTAssertNotNil(details, "Movie details should be fetched successfully.")
            XCTAssertEqual(details.id, 1011985)
        } catch {
            XCTFail("Fetching movie details failed when it should have succeeded.")
        }
    }

    func testFetchPopularMoviesWithError() async {
        let api = MockAPIProvider()
        api.shouldThrowError = true

        let repository = TMDBMoviesRepository(api: api, cache: MockCacheProvider())

        do {
            _ = try await repository.fetchPopularMovies(page: 1)
            XCTFail("Fetching movies should have failed.")
        } catch {
            XCTAssertTrue(error is URLError, "Error should be a URLError.")
        }
    }

    func testPopularMoviesCaching() async {
        let api = MockAPIProvider()
        api.data = moviesData
        let cache = MockCacheProvider()
        let repository = TMDBMoviesRepository(api: api, cache: cache)

        _ = try? await repository.fetchPopularMovies(page: 1)

        guard let cachedData = cache.cache[CacheKey.popularMovies(page: 1).rawValue] else {
            XCTFail("Movies should be cached after fetching.")
            return
        }

        XCTAssertNotNil(cachedData, "Fetched movies should be cached.")
        let movies = try? JSONDecoder().decode([Movie].self, from: cachedData)
        XCTAssertEqual(movies?.first?.id, 1011985)
        XCTAssertEqual(movies?.first?.title, "Kung Fu Panda 4")
    }

    func testMovieDetailsCaching() async {
        let api = MockAPIProvider()
        api.data = movieDetailsData
        let cache = MockCacheProvider()
        let repository = TMDBMoviesRepository(api: api, cache: cache)

        _ = try? await repository.fetchMovieDetails(id: 1)

        // Check if the data is cached
        guard let cachedData = cache.cache[CacheKey.movieDetails(id: 1).rawValue] else {
            XCTFail("Movie details should be cached after fetching.")
            return
        }

        XCTAssertNotNil(cachedData, "Fetched movie details should be cached.")
        let details = try? JSONDecoder().decode(MovieDetails.self, from: cachedData)
        XCTAssertEqual(details?.id, 1011985)
        XCTAssertEqual(details?.title, "Kung Fu Panda 4")
        XCTAssertEqual(details?.releaseDate, "2024-03-02")
        XCTAssertEqual(details?.voteAverage, 6.86)
        XCTAssertEqual(details?.budget, 85000000)
        XCTAssertEqual(details?.genres, ["Action", "Adventure"])
        XCTAssertEqual(details?.overview, "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.")
        XCTAssertEqual(details?.revenue, 176000000)
        XCTAssertEqual(details?.runtime, 94)
        XCTAssertNotNil(details?.backdropPath)
        XCTAssertNotNil(details?.posterPath)
    }

    func testPopularMoviesParsingWithMissingData() async {
        let api = MockAPIProvider()
        api.data = incompleteMoviesData

        let repository = TMDBMoviesRepository(api: api, cache: MockCacheProvider())

        do {
            let movies = try await repository.fetchPopularMovies(page: 1)
            XCTAssertFalse(movies.isEmpty, "Movies should be fetched successfully.")
            XCTAssertEqual(movies.first?.id, 1011985)
            XCTAssertEqual(movies.first?.title, "Kung Fu Panda 4")
            XCTAssertNil(movies.first?.posterPath)
        } catch {
            XCTFail("Fetching movie details with missing data should not fail.")
        }
    }

    func testMovieDetailsParsingWithMissingData() async {
        let api = MockAPIProvider()
        api.data = incompleteMovieDetailsData

        let repository = TMDBMoviesRepository(api: api, cache: MockCacheProvider())

        do {
            let details = try await repository.fetchMovieDetails(id: 1)
            XCTAssertEqual(details.id, 1011985)
            XCTAssertEqual(details.title, "Kung Fu Panda 4")
            XCTAssertNil(details.runtime)
            XCTAssertNil(details.budget)
            XCTAssertNil(details.revenue)
            XCTAssertNil(details.posterPath)
            XCTAssertNil(details.backdropPath)
            XCTAssertTrue(details.genres.isEmpty, "Genres should be empty but not nil.")
            XCTAssertTrue(details.cast.isEmpty, "Cast should be empty but not nil.")
        } catch {
            XCTFail("Fetching movie details with missing data should not fail.")
        }
    }

    private let moviesData = """
    {
        "page": 1,
        "results": [
            {
                "id": 1011985,
                "title": "Kung Fu Panda 4",
                "poster_path": "/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg"
            }
        ],
        "total_pages": 43150,
        "total_results": 862984
    }
    """.data(using: .utf8)
    private let incompleteMoviesData = """
    {
        "page": 1,
        "results": [
            {
                "id": 1011985,
                "title": "Kung Fu Panda 4"
            }
        ],
        "total_pages": 43150,
        "total_results": 862984
    }
    """.data(using: .utf8)
    private let movieDetailsData = """
    {
        "backdrop_path": "/1XDDXPXGiI8id7MrUxK36ke7gkX.jpg",
        "budget": 85000000,
        "genres": [
            {
                "id": 28,
                "name": "Action"
            },
            {
                "id": 12,
                "name": "Adventure"
            }
        ],
        "id": 1011985,
        "overview": "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.",
        "poster_path": "/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg",
        "release_date": "2024-03-02",
        "revenue": 176000000,
        "runtime": 94,
        "title": "Kung Fu Panda 4",
        "vote_average": 6.86,
        "credits": {
            "cast": [
                {
                    "adult": false,
                    "gender": 2,
                    "id": 70851,
                    "known_for_department": "Acting",
                    "name": "Jack Black",
                    "original_name": "Jack Black",
                    "popularity": 54.606,
                    "profile_path": "/rtCx0fiYxJVhzXXdwZE2XRTfIKE.jpg",
                    "cast_id": 1,
                    "character": "Po (voice)",
                    "credit_id": "62fae24c303c85008229904c",
                    "order": 0
                },
                {
                    "adult": false,
                    "gender": 1,
                    "id": 1625558,
                    "known_for_department": "Acting",
                    "name": "Awkwafina",
                    "original_name": "Awkwafina",
                    "popularity": 36.704,
                    "profile_path": "/l5AKkg3H1QhMuXmTTmq1EyjyiRb.jpg",
                    "cast_id": 8,
                    "character": "Zhen (voice)",
                    "credit_id": "64c11f44ede1b000af4c3e14",
                    "order": 1
                }
            ]
        },
        "recommendations": {
            "page": 1,
            "results": [
                {
                    "id": 1011985,
                    "title": "Kung Fu Panda 4",
                    "poster_path": "/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg"
                }
            ],
            "total_pages": 0,
            "total_results": 0
        }
    }
    """.data(using: .utf8)
    private let incompleteMovieDetailsData = """
    {
        "genres": [],
        "id": 1011985,
        "overview": "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.",
        "release_date": "",
        "title": "Kung Fu Panda 4",
        "vote_average": 6.86,
        "credits": {
            "cast": []
        },
        "recommendations": {
            "page": 1,
            "results": [],
            "total_pages": 0,
            "total_results": 0
        }
    }
    """.data(using: .utf8)
}
