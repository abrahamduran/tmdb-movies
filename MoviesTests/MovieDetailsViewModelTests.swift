//
//  MovieDetailsViewModelTests.swift
//  MoviesTests
//
//  Created by Abraham Duran on 3/23/24.
//

import XCTest
@testable import Movies

final class MovieDetailsViewModelTests: XCTestCase {

    func testSuccessfulDataFetch() async {
        let expected = MovieDetails.mock()
        let repository = MockMoviesRepository()
        repository.movieDetails = expected

        let viewModel = await MovieDetailsViewModel(repository: repository, offlineCache: MockMoviesRepository())

        let testMovie = Movie(id: 1, title: "Test Movie", posterPath: "")
        await viewModel.fetchDetails(for: testMovie)

        switch await viewModel.content {
        case .content(let result):
            XCTAssertEqual(result.id, expected.id)
            XCTAssertEqual(result.title, expected.title)
        default:
            XCTFail("Content was not loaded successfully.")
        }
    }

    func testFetchingDataWithNetworkError() async {
        let repository = MockMoviesRepository()
        repository.shouldThrowError = true

        let viewModel = await MovieDetailsViewModel(repository: repository, offlineCache: MockMoviesRepository())

        let testMovie = Movie(id: 1, title: "Test Movie", posterPath: "")
        await viewModel.fetchDetails(for: testMovie)

        let error = await viewModel.error
        let content = await viewModel.content
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .noNetworkConnection)
        XCTAssertEqual(content, .error)
    }

    func testLoadingFromOfflineCacheOnError() async {
        let onlineRepository = MockMoviesRepository()
        onlineRepository.shouldThrowError = true

        let expected = MovieDetails.mock(title: "Cached Movie")
        let offlineRepository = MockMoviesRepository()
        offlineRepository.movieDetails = expected

        let viewModel = await MovieDetailsViewModel(repository: onlineRepository, offlineCache: offlineRepository)

        let testMovie = Movie(id: 1, title: "Cached Movie", posterPath: "/cached.jpg")
        await viewModel.fetchDetails(for: testMovie)

        switch await viewModel.content {
        case .content(let result):
            XCTAssertEqual(result.id, expected.id)
            XCTAssertEqual(result.title, expected.title)
        default:
            XCTFail("Content was not loaded from offline cache.")
        }

        let error = await viewModel.error
        XCTAssertNotNil(error)
    }

    func testRefreshDetails() async {
        let expected = MovieDetails.mock(title: "Refreshed Movie")
        let repository = MockMoviesRepository()
        repository.movieDetails = MovieDetails.mock(title: "Unrefreshed Movie")

        let viewModel = await MovieDetailsViewModel(repository: repository, offlineCache: MockMoviesRepository())

        let testMovie = Movie(id: 1, title: "Test Movie", posterPath: "/test.jpg")
        await viewModel.fetchDetails(for: testMovie)

        repository.movieDetails = expected
        await viewModel.refreshDetails(for: testMovie)

        switch await viewModel.content {
        case .content(let result):
            XCTAssertEqual(result.title, expected.title)
        default:
            XCTFail("Content was not refreshed successfully.")
        }
    }
}
