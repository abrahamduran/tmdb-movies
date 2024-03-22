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
    @Published private(set) var error: UserError? = nil
    @Published var showErrorAlert = false

    private var repository: MoviesRepository

    init(repository: MoviesRepository = MoviesRepository()) {
        self.repository = repository
    }

    func fetchDetails(for movie: Movie) async {
        guard content.model == nil else { return }
        await fetchMovieDetails(movie)
    }

    func refreshDetails(for movie: Movie) async {
        await fetchMovieDetails(movie)
    }

    private func fetchMovieDetails(_ movie: Movie) async {
        do {
            let details = try await repository.fetchMovieDetails(id: movie.id)
            content = .content(details)
        } catch {
            // Normally, the original error would be logged to the monitoring platform for tracking and evaluation
            print("Error fetching movie details: \(error)")
            self.error = UserError.failedRequest
            if content == .loading {
                self.content = .error
            } else {
                self.showErrorAlert = true
            }
        }
    }
}
