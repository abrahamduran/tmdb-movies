//
//  MovieDetailsResponse.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

struct MovieDetailsResponse: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let runtime: Int?
    let budget: Int?
    let revenue: Int?
    let overview: String
    let posterPath: String
    let backdropPath: String
    let voteAverage: Double
    let genres: [Genre]
    let credits: Credits
    let recommendations: MoviesPageResponse

    struct Credits: Decodable {
        let cast: [CastMember]
    }
}

extension MovieDetails {
    init(response: MovieDetailsResponse) {
        self.id = response.id
        self.title = response.title
        self.releaseDate = response.releaseDate
        self.runtime = response.runtime
        self.budget = response.budget
        self.revenue = response.revenue
        self.overview = response.overview
        self.posterPath = response.posterPath
        self.backdropPath = response.backdropPath
        self.voteAverage = response.voteAverage
        self.cast = response.credits.cast
        self.genres = response.genres
        self.recommendations = response.recommendations.results
    }
}
