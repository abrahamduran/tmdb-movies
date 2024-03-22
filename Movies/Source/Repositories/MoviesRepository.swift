//
//  MoviesRepository.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import Foundation

//protocol MoviesFetcher {
//    func get() async throws -> [Cat]
//    func get(byIdentifier: String) async throws -> Cat
//}
//
//protocol MoviesStore: MoviesFetcher {
//    func save(_ cat: Cat) async throws
//}
//
//enum CatRepositoryError: Error {
//    case notFound, notSaved
//}

final class MoviesRepository {
    private let tmdbAPI: TMDBAPI
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }

    init(tmdbAPI: TMDBAPI = TMDBAPI()) {
        self.tmdbAPI = tmdbAPI
    }

    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular") else {
            throw URLError(.badURL)
        }

        let parameters = [URLQueryItem(name: "page", value: String(page))]
        let data = try await tmdbAPI.fetch(from: url, parameters: parameters)
        let response = try decoder.decode(MoviesPageResponse.self, from: data)
        return response.results
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)") else {
            throw URLError(.badURL)
        }
        let parameters = [URLQueryItem(name: "append_to_response", value: "credits,recommendations")]
        let detailsData = try await tmdbAPI.fetch(from: url, parameters: parameters)
        let response = try decoder.decode(MovieDetailsResponse.self, from: detailsData)
        return .init(response: response)
    }
}
