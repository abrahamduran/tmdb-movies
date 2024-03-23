//
//  MoviesRepository.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import Foundation

protocol MoviesRepository {
    func fetchPopularMovies(page: Int) async throws -> [Movie]
    func fetchMovieDetails(id: Int) async throws -> MovieDetails
}

final class TMDBMoviesRepository: MoviesRepository {
    private let api: APIProvider
    private let cache: CacheProvider
    private lazy var posterBasePath: String = {
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "TMDBPosterPath") as? String else {
            assertionFailure("TMDBPosterPath not found in Info.plist")
            return "https://image.tmdb.org/t/p/w500"
        }
        return basePath
    }()
    private lazy var profileBasePath: String = {
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "TMDBProfilePath") as? String else {
            assertionFailure("TMDBProfilePath not found in Info.plist")
            return "https://image.tmdb.org/t/p/h632"
        }
        return basePath
    }()
    private lazy var backdropBasePath: String = {
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "TMDBBackdropPath") as? String else {
            assertionFailure("TMDBBackdropPath not found in Info.plist")
            return "https://image.tmdb.org/t/p/w1280"
        }
        return basePath
    }()
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }

    init(api: APIProvider = TMDBAPI(), cache: CacheProvider = UserDefaultsCacheProvider()) {
        self.api = api
        self.cache = cache
    }

    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular") else {
            throw URLError(.badURL)
        }

        let parameters = [URLQueryItem(name: "page", value: String(page))]
        let data = try await api.fetch(from: url, parameters: parameters)
        let response = try decoder.decode(MoviesPageResponse.self, from: data)
        let result = response.results.map { Movie(id: $0.id, title: $0.title, posterPath: $0.posterPath == nil ? nil : posterBasePath + $0.posterPath!) }
        cacheResponse(result, forKey: .popularMovies(page: page))

        return result
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)") else {
            throw URLError(.badURL)
        }
        let parameters = [URLQueryItem(name: "append_to_response", value: "credits,recommendations")]
        let data = try await api.fetch(from: url, parameters: parameters)
        let response = try decoder.decode(MovieDetailsResponse.self, from: data)
        let result = MovieDetails(response: response, posterBasePath: posterBasePath, profileBasePath: profileBasePath, backdropBasePath: backdropBasePath)
        cacheResponse(result, forKey: .movieDetails(id: id))

        return result
    }

    private func cacheResponse<T: Encodable>(_ model: T, forKey key: CacheKey) {
        guard let data = try? JSONEncoder().encode(model) else { return }
        cache.cacheData(data, forKey: key)
    }
}

final class CacheMoviesRepository: MoviesRepository {
    private let cache: CacheProvider

    init(cache: CacheProvider = UserDefaultsCacheProvider()) {
        self.cache = cache
    }

    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        let data = try cache.fetchCachedData(forKey: .popularMovies(page: page))
        return try JSONDecoder().decode([Movie].self, from: data)
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        let data = try cache.fetchCachedData(forKey: .movieDetails(id: id))
        return try JSONDecoder().decode(MovieDetails.self, from: data)
    }
}
