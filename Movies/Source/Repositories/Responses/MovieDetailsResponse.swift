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
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let genres: [Genre]
    let credits: Credits
    let recommendations: MoviesPageResponse

    struct Credits: Decodable {
        let cast: [CastMember]
    }

    struct Genre: Decodable {
        let id: Int
        let name: String
    }
}

extension MovieDetails {
    init(response: MovieDetailsResponse, posterBasePath: String, profileBasePath: String, backdropBasePath: String) {
        self.id = response.id
        self.title = response.title
        self.releaseDate = response.releaseDate
        self.runtime = response.runtime
        self.budget = response.budget
        self.revenue = response.revenue
        self.overview = response.overview
        self.posterPath = response.posterPath == nil ? nil : posterBasePath + response.posterPath!
        self.backdropPath = response.backdropPath == nil ? nil : backdropBasePath + response.backdropPath!
        self.voteAverage = response.voteAverage
        self.genres = response.genres.map(\.name)
        self.recommendations = response.recommendations.results
            .map { .init(id: $0.id, title: $0.title, posterPath: $0.posterPath == nil ? nil : posterBasePath + $0.posterPath!) }
        self.cast = response.credits.cast
            .map { .init(id: $0.id, name: $0.name, character: $0.character, profilePath: $0.profilePath == nil ? nil : profileBasePath + $0.profilePath!) }
    }
}
