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
    @Published private(set) var error: AppError? = nil
    @Published var showErrorAlert = false
    private var currentPage = 1
    private var hasMorePages = true
    private var fetchHistory = Set<Int>()
    private var fetchedMovies = [Movie]()

    private var repository: MoviesRepository
    private var offlineCache: MoviesRepository

    init(repository: MoviesRepository = TMDBMoviesRepository(), offlineCache: MoviesRepository = CacheMoviesRepository()) {
        self.repository = repository
        self.offlineCache = offlineCache
    }

    func fetchContent() async {
        // Avoid fetching content if we are already showing content
        guard content.model == nil else { return }

        // Fetch the cached data for faster loads
        if let cachedMovies = try? await offlineCache.fetchPopularMovies(page: currentPage) {
            content = .content(cachedMovies)
        }

        await fetchPopularMovies()
    }

    func refreshContent() async {
        currentPage = 1
        hasMorePages = true
        fetchHistory = []
        fetchedMovies = []
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
#if DEBUG
        if ProcessInfo.processInfo.environment["UI_TESTING_ERROR_STATE"] == "Popular-Movies-1" {
            // Simulate an error state
            self.content = .error
            return
        } else if ProcessInfo.processInfo.environment["UI_TESTING_LOADING_STATE"] == "Popular-Movies-1" {
            // Simulate loading state
            self.content = .loading
            return
        }
#endif
        var newMovies: [Movie]?
        var appError: AppError?

        // Fetch content from the API
        do {
            newMovies = try await repository.fetchPopularMovies(page: currentPage)
        } catch URLError.notConnectedToInternet {
            appError = .noNetworkConnection
        } catch {
            // Normally, the original error would be logged to the monitoring platform for tracking and evaluation
            print("Error fetching movies: \(error)")
            appError = .failedRequest
        }

        // If unable to fetch content from API, try the fetching from the cache
        if newMovies == nil {
            do {
                print("Fetching movies from cache")
                newMovies = try await offlineCache.fetchPopularMovies(page: currentPage)
            } catch AppError.invalidCache {
                appError = .invalidCache
            } catch {
                print("Error fetching movies from offline cache: \(error)")
            }
        }

        // Notify user of any errors
        if let appError {
            handleError(appError)
        }
        guard let newMovies else { return }
        updateContent(with: newMovies)
    }

    private func updateContent(with newMovies: [Movie]) {
        let fullList = fetchedMovies + newMovies
        if newMovies.isEmpty {
            hasMorePages = false
        } else {
            content = .content(fullList)
            currentPage += 1
        }
        if let id = fetchedMovies.last?.id {
            fetchHistory.insert(id)
        }

        fetchedMovies = fullList
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
