//
//  MovieDetails+Mock.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

extension MovieDetails {
    static func mock(
        id: Int = 1, title: String = "Test Movie", releaseDate: String = "2024-03-22", runtime: Int? = 120,
        budget: Int? = 100000000, revenue: Int? = 500000000, overview: String = "Test Overview",
        posterPath: String? = "https://image.tmdb.org/t/p/w500/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg",
        backdropPath: String? = "https://image.tmdb.org/t/p/w1280/deLWkOLZmBNkm8p16igfapQyqeq.jpg",
        voteAverage: Double = 8.0, cast: [CastMember] = [.mock()], genres: [String] = ["Action", "Comedy"], recommendations: [Movie] = [.mock()]
    ) -> MovieDetails {
        .init(id: id, title: title, releaseDate: releaseDate, runtime: runtime, budget: budget, revenue: revenue, overview: overview, posterPath: posterPath, backdropPath: backdropPath, voteAverage: voteAverage, cast: cast, genres: genres, recommendations: recommendations)
    }
}
