//
//  MoviesApp.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import SwiftUI
import Kingfisher
@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PopularMoviesView()
            }
        }
    }
}
