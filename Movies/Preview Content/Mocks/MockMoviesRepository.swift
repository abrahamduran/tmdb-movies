//
//  MockMoviesRepository.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

final class MockMoviesRepository: MoviesRepository {
    private(set) var requestedPage: Int = 0
    var movies: [Movie] = []
    var movieDetails: MovieDetails?
    var shouldThrowError: Bool = false
    var errorToThrow: Error = URLError(.notConnectedToInternet)

    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        requestedPage = page
        if shouldThrowError {
            throw errorToThrow
        }
        return movies
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let details = movieDetails else {
            throw AppError.failedRequest
        }
        return details
    }
}
