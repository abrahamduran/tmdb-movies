//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

@MainActor
final class MovieDetailsViewModel: ObservableObject {
    @Published private(set) var content: ContentState<MovieDetails> = .loading
    @Published private(set) var error: AppError? = nil
    @Published var showErrorAlert = false

    private var repository: MoviesRepository
    private var offlineCache: MoviesRepository

    init(repository: MoviesRepository = TMDBMoviesRepository(), offlineCache: MoviesRepository = CacheMoviesRepository()) {
        self.repository = repository
        self.offlineCache = offlineCache
    }

    func fetchDetails(for movie: Movie) async {
        // Avoid fetching content if we are already showing content
        guard content.model == nil else { return }
        await fetchMovieDetails(movie)
    }

    func refreshDetails(for movie: Movie) async {
        await fetchMovieDetails(movie)
    }

    private func fetchMovieDetails(_ movie: Movie) async {
        var details: MovieDetails?
        var appError: AppError?

        do {
            details = try await repository.fetchMovieDetails(id: movie.id)
        } catch URLError.notConnectedToInternet {
            appError = .noNetworkConnection
        } catch {
            // Normally, the original error would be logged to the monitoring platform for tracking and evaluation
            print("Error fetching movie details: \(error)")
            appError = .failedRequest
        }

        if details == nil {
            do {
                details = try await offlineCache.fetchMovieDetails(id: movie.id)
            } catch AppError.invalidCache {
                appError = .invalidCache
            } catch {
                print("Error fetching movie details from offline cache: \(error)")
            }
        }
        
        if let appError {
            handleError(appError)
        }

        guard let details else { return }
        content = .content(details)
    }

    private func handleError(_ error: AppError) {
        self.error = error
        if content == .loading {
            self.content = .error
        } else {
            self.showErrorAlert = true
        }
    }
}
