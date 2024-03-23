//
//  MovieDetailsViewTests.swift
//  MoviesUITests
//
//  Created by Abraham Duran on 3/23/24.
//

import XCTest

final class MovieDetailsViewTests: XCTestCase {
    func testMovieDetailsLoadingState() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UI_TESTING_LOADING_STATE": "Movie-Details-1"]
        app.launch()

        // Assuming there's a way to navigate to the details view in your app
        navigateToMovieDetailsView(with: app)

        // Check for the loading indicator
        let loadingIndicator = app.activityIndicators.firstMatch
        XCTAssertTrue(loadingIndicator.waitForExistence(timeout: 5), "Loading indicator should be visible while fetching movie details.")
    }
    
    func testMovieDetailsContentDisplay() {
        let app = XCUIApplication()
        app.launch()

        navigateToMovieDetailsView(with: app)

        let detailsView = app.scrollViews["MovieDetailsView"]
        XCTAssertTrue(detailsView.waitForExistence(timeout: 5))

        let header = detailsView.images["DetailsView.Header"].firstMatch
        XCTAssertTrue(header.waitForExistence(timeout: 10), "Movie details should be visible after loading.")
    }

    func testMovieDetailsErrorState() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UI_TESTING_ERROR_STATE": "Movie-Details-1"]
        app.launch()

        navigateToMovieDetailsView(with: app)
        
        let detailsView = app.scrollViews["MovieDetailsView"]
        XCTAssertTrue(detailsView.waitForExistence(timeout: 5))

        let errorMessage = detailsView.staticTexts["ErrorView"]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 10), "Error message should be visible when fetching movie details fails.")
    }

    private func navigateToMovieDetailsView(with app: XCUIApplication) {
        let movieCell = app.scrollViews["PopularMoviesView"].buttons.firstMatch
        XCTAssertTrue(movieCell.waitForExistence(timeout: 5))
        movieCell.tap()
    }
}
