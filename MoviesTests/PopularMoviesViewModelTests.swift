//
//  PopularMoviesViewModelTests.swift
//  MoviesTests
//
//  Created by Abraham Duran on 3/22/24.
//

import XCTest
@testable import Movies

final class PopularMoviesViewModelTests: XCTestCase {

    func testContentStateLoading() async {
        let repository = MockMoviesRepository()

        let viewModel = await PopularMoviesViewModel(repository: repository, offlineCache: MockMoviesRepository())

        // Trigger the content fetch but don't await the result to check the immediate state
        Task {
            await viewModel.fetchContent()
        }

        let content = await viewModel.content
        XCTAssertEqual(content, .loading, "Content state should be loading immediately after fetchContent is called.")
    }

    func testFetchContentSuccess() async {
        let repository = MockMoviesRepository()
        repository.movies = [Movie(id: 1, title: "Test Movie", posterPath: "")]
        let viewModel = await PopularMoviesViewModel(repository: repository, offlineCache: MockMoviesRepository())

        await viewModel.fetchContent()

        switch await viewModel.content {
        case .content(let movies):
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.first?.title, "Test Movie")
        default:
            XCTFail("Content was not loaded successfully.")
        }
    }

    func testErrorStateAfterLoading() async {
        let onlineRepository = MockMoviesRepository()
        onlineRepository.shouldThrowError = true
        let offlineRepository = MockMoviesRepository()
        offlineRepository.shouldThrowError = true

        let viewModel = await PopularMoviesViewModel(repository: onlineRepository, offlineCache: offlineRepository)

        await viewModel.fetchContent()

        let content = await viewModel.content
        XCTAssertEqual(content, .error, "Content state should transition to error after a failure during loading.")
    }

    func testContentStateAfterFailedFetch() async {
        let repository = MockMoviesRepository()
        repository.movies = [Movie(id: 1, title: "Test Movie", posterPath: "")]

        let viewModel = await PopularMoviesViewModel(repository: repository, offlineCache: MockMoviesRepository())

        await viewModel.fetchContent()

        repository.shouldThrowError = true
        
        if let movie = repository.movies.first {
            await viewModel.onItemAppear(movie)
        }

        let content = await viewModel.content
        let error = await viewModel.error
        let showError = await viewModel.showErrorAlert
        XCTAssertNotEqual(content, .error, "Content state should not transition to error after a failure when content is already present.")
        XCTAssertNotNil(error)
        XCTAssertTrue(showError)
    }

    func testFetchContentNoNetwork() async {
        let repository = MockMoviesRepository()
        repository.shouldThrowError = true
        repository.errorToThrow = URLError(.notConnectedToInternet)

        let viewModel = await PopularMoviesViewModel(repository: repository, offlineCache: MockMoviesRepository())

        await viewModel.fetchContent()

        let error = await viewModel.error
        XCTAssertNotNil(error)
        XCTAssertEqual(error, AppError.noNetworkConnection)
    }

    func testPaginationFetchNextPage() async {
        let repository = MockMoviesRepository()
        repository.movies = [Movie(id: 1, title: "Test Movie", posterPath: "")]

        let viewModel = await PopularMoviesViewModel(repository: repository, offlineCache: MockMoviesRepository())
        await viewModel.fetchContent()

        repository.movies = repository.movies + [Movie(id: 2, title: "Test Movie 2", posterPath: "")]
        // Simulate that the last item appeared to trigger fetching the next page
        if let movie = repository.movies.first {
            await viewModel.onItemAppear(movie)
        }

        switch await viewModel.content {
        case .content(let movies):
            XCTAssertEqual(repository.requestedPage, 2)
            XCTAssertEqual(movies.last?.title, "Test Movie 2")
        default:
            XCTFail("Next page was not loaded successfully.")
        }
    }

    func testRefreshContent() async {
        let repository = MockMoviesRepository()
        repository.movies = [Movie(id: 1, title: "Test Movie", posterPath: ""), Movie(id: 2, title: "Test Movie 2", posterPath: "")]

        let viewModel = await PopularMoviesViewModel(repository: repository, offlineCache: MockMoviesRepository())
        await viewModel.fetchContent()

        repository.movies = [Movie(id: 1, title: "Test Movie", posterPath: "")]
        await viewModel.refreshContent()
        
        switch await viewModel.content {
        case .content(let movies):
            XCTAssertEqual(repository.requestedPage, 1)
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.last?.title, "Test Movie")
        default:
            XCTFail("Content was not refreshed successfully.")
        }
    }

    func testLoadingFromCacheOnAPIFailure() async {
        let onlineRepository = MockMoviesRepository()
        onlineRepository.shouldThrowError = true // Simulate API failure

        let offlineRepository = MockMoviesRepository()
        offlineRepository.movies = [Movie(id: 1, title: "Cached Movie", posterPath: "")] // Simulate cached data

        let viewModel = await PopularMoviesViewModel(repository: onlineRepository, offlineCache: offlineRepository)

        await viewModel.fetchContent()

        switch await viewModel.content {
        case .content(let movies):
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.first?.title, "Cached Movie")
        default:
            XCTFail("Content was not loaded from cache.")
        }
    }

    func testOfflineCacheFailure() async {
        let onlineRepository = MockMoviesRepository()
        onlineRepository.shouldThrowError = true // Simulate API failure
        onlineRepository.errorToThrow = URLError(.badURL)

        let offlineRepository = MockMoviesRepository()
        offlineRepository.shouldThrowError = true // Simulate cache failure

        let viewModel = await PopularMoviesViewModel(repository: onlineRepository, offlineCache: offlineRepository)

        await viewModel.fetchContent()

        let error = await viewModel.error
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .failedRequest)
    }

    func testOfflineInvalidCache() async {
        let onlineRepository = MockMoviesRepository()
        onlineRepository.shouldThrowError = true // Simulate API failure

        let offlineRepository = MockMoviesRepository()
        offlineRepository.shouldThrowError = true // Simulate cache failure
        offlineRepository.errorToThrow = AppError.invalidCache

        let viewModel = await PopularMoviesViewModel(repository: onlineRepository, offlineCache: offlineRepository)

        await viewModel.fetchContent()

        let error = await viewModel.error
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .invalidCache)
    }

    func testRefreshClearsCache() async {
        let onlineRepository = MockMoviesRepository()
        onlineRepository.movies = [Movie(id: 1, title: "New Movie", posterPath: "")]
        onlineRepository.shouldThrowError = true

        let offlineRepository = MockMoviesRepository()
        offlineRepository.movies = [Movie(id: 1, title: "Cached Movie", posterPath: "")]

        let viewModel = await PopularMoviesViewModel(repository: onlineRepository, offlineCache: offlineRepository)

        // Initial load from cache
        await viewModel.fetchContent()

        switch await viewModel.content {
        case .content(let movies):
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.first?.title, "Cached Movie")
        default:
            XCTFail("Content was not fetched from cache.")
        }

        onlineRepository.shouldThrowError = false

        // Refresh should attempt to load from online repository again
        await viewModel.refreshContent()

        switch await viewModel.content {
        case .content(let movies):
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.first?.title, "New Movie")
        default:
            XCTFail("Content was not refreshed correctly.")
        }
    }

    func testInitialFetchFromCache() async throws {
        let expectation = expectation(description: "testInitialFetchFromCache")
        let onlineRepository = MockMoviesRepository()
        onlineRepository.movies = [Movie(id: 1, title: "Online Movie", posterPath: "")]

        let offlineRepository = MockMoviesRepository()
        offlineRepository.movies = [Movie(id: 1, title: "Cached Movie", posterPath: "")]

        let viewModel = await PopularMoviesViewModel(repository: onlineRepository, offlineCache: offlineRepository)

        let content = await viewModel.$content
            .collect(3)
            .sink { values in
                let cached = values[1].model
                let online = values[2].model
                XCTAssertEqual(cached?.first?.title, "Cached Movie")
                XCTAssertEqual(online?.first?.title, "Online Movie")
                expectation.fulfill()
            }

        await viewModel.fetchContent()

        await fulfillment(of: [expectation])
        content.cancel()
    }
}
