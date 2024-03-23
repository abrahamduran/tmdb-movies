//
//  MovieDetailsPresentation.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

struct MovieDetailsPresentation: Identifiable, Equatable {
    let id: Int
    let title: String
    let releaseYear: String
    let releaseDate: String
    let runtime: String
    let budget: String
    let revenue: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let rating: String
    let genres: String
    let cast: [CastMember]
    let recommendations: [Movie]
}

extension MovieDetailsPresentation {
    init(from domain: MovieDetails, dateFormatter: DateFormatter, runtimeFormatter: DateComponentsFormatter, currencyFormatter: NumberFormatter, ratingFormatter: NumberFormatter) {
        self.id = domain.id
        self.title = domain.title
        self.releaseYear = String(domain.releaseDate.prefix(4))
        self.overview = domain.overview
        self.posterPath = domain.posterPath
        self.backdropPath = domain.backdropPath
        self.cast = domain.cast
        self.recommendations = domain.recommendations
        self.genres = domain.genres.joined(separator: ", ")

        if let date = dateFormatter.date(from: domain.releaseDate) {
            self.releaseDate = date.formatted(date: .long, time: .omitted)
        } else {
            self.releaseDate = domain.releaseDate
        }

        let ratingString = ratingFormatter.string(from: NSNumber(value: domain.voteAverage)) ?? "\(domain.voteAverage)"
        self.rating = "Rating: \(ratingString)/10"
        if let budget = domain.budget, let string = currencyFormatter.string(from: NSNumber(value: budget)) {
            self.budget = string
        } else {
            self.budget = "N/A"
        }
        if let revenue = domain.revenue, let string = currencyFormatter.string(from: NSNumber(value: revenue)) {
            self.revenue = string
        } else {
            self.revenue = "N/A"
        }
        if let runtime = domain.runtime, let string = runtimeFormatter.string(from: TimeInterval(runtime * 60)) {
            self.runtime = string
        } else {
            self.runtime = "N/A"
        }
    }
}
