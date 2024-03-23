//
//  PopularMoviesViewTests.swift
//  MoviesUITests
//
//  Created by Abraham Duran on 3/21/24.
//

import XCTest

final class PopularMoviesViewTests: XCTestCase {
    func testNavigationBarTitle() {
        let app = XCUIApplication()
        app.launch()

        // Wait for the grid to appear by checking for the existence of a cell
        let navigationBar = app.navigationBars["Popular Movies"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5))
    }

    func testPopularMoviesLoadingState() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UI_TESTING_LOADING_STATE": "Popular-Movies-1"]
        app.launch()

        // Check for the loading indicator
        let loadingIndicator = app.activityIndicators.firstMatch
        XCTAssertTrue(loadingIndicator.waitForExistence(timeout: 5), "Loading indicator should be visible while fetching movie details.")
    }

    func testPopularMoviesContentDisplay() {
        let app = XCUIApplication()
        app.launch()

        // Wait for the grid to appear by checking for the existence of a cell
        let scrollView = app.scrollViews["PopularMoviesView"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))

        let cell = scrollView.buttons["MovieCell"]
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "The movies grid should appear with content.")
    }

    func testMovieDetailsErrorState() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UI_TESTING_ERROR_STATE": "Popular-Movies-1"]
        app.launch()

        let scrollView = app.scrollViews["PopularMoviesView"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))

        let errorMessage = scrollView.staticTexts["ErrorView"]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 10), "Error message should be visible when fetching movie details fails.")
    }

    func testContentIsScrollable() {
        let app = XCUIApplication()
        app.launch()

        // Wait for the grid to appear by checking for the existence of a cell
        let scrollView = app.scrollViews["PopularMoviesView"]
        let cell = scrollView.buttons["MovieCell"].firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.isHittable)

        scrollView.swipeUp()
        scrollView.swipeUp()

        XCTAssertFalse(cell.isHittable)
    }
}
