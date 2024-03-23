//
//  MovieDetails.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

struct MovieDetails: Identifiable, Codable, Equatable {
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
    let cast: [CastMember]
    let genres: [Genre]
    let recommendations: [Movie]
}
