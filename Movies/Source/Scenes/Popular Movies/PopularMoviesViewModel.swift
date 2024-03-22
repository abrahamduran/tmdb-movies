//
//  PopularMoviesViewModel.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import Foundation

@MainActor
final class PopularMoviesViewModel: ObservableObject {
    @Published private(set) var content: ContentState<[Movie]> = .loading
    @Published private(set) var isLoadingPage = false
    @Published private(set) var error: UserError? = nil
    @Published var showErrorAlert = false
    private var currentPage = 1
    private var hasMorePages = true
    private var fetchHistory = Set<Int>()

    private var repository: MoviesRepository

    init(repository: MoviesRepository = MoviesRepository()) {
        self.repository = repository
    }

    func fetchContent() async {
        guard content.model == nil else { return }
        await fetchPopularMovies()
    }

    func refreshContent() async {
        currentPage = 1
        hasMorePages = true
        fetchHistory = []
        await fetchPopularMovies()
    }

    func onItemAppear(_ movie: Movie) async {
        // Verify there are more pages available, and we are not currently fetching
        guard hasMorePages, isLoadingPage == false else { return }

        // Verify threshold: last movie will appear
        guard let movies = content.model, movie.id == movies.last?.id else { return }

        // Avoid duplicated requests
        guard fetchHistory.contains(movie.id) == false else { return }

        isLoadingPage = true

        await fetchPopularMovies()

        isLoadingPage = false
    }

    private func fetchPopularMovies() async {
        do {
            let currentMovies = content.model ?? []
            let newMovies = try await repository.fetchPopularMovies(page: currentPage)
            if newMovies.isEmpty {
                hasMorePages = false
            } else {
                content = .content(currentMovies + newMovies)
                currentPage += 1
            }
            if let id = currentMovies.last?.id {
                fetchHistory.insert(id)
            }
        } catch {
            // Normally, the original error would be logged to the monitoring platform for tracking and evaluation
            print("Error fetching movies: \(error)")
            self.error = UserError.failedRequest
            if content == .loading {
                self.content = .error
            } else {
                self.showErrorAlert = true
            }
        }
    }
}
