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
    let generalInformation: [GeneralInformation]
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let rating: String
    let genres: String
    let cast: [CastMember]
    let recommendations: [Movie]

    struct GeneralInformation: Equatable {
        let title: String
        let information: Information
    }
    enum Information: Equatable {
        case content(String), empty(String)

        var value: String {
            switch self {
            case .content(let s): return s
            case .empty(let s): return s
            }
        }

        var isEmpty: Bool {
            guard case .empty = self else { return false }
            return true
        }
    }
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

        let ratingString = ratingFormatter.string(from: NSNumber(value: domain.voteAverage)) ?? "\(domain.voteAverage)"
        self.rating = "Rating: \(ratingString)/10"

        var releaseDate = Information.content(domain.releaseDate)
        if let date = dateFormatter.date(from: domain.releaseDate) {
            releaseDate = .content(date.formatted(date: .long, time: .omitted))
        } else if domain.releaseDate.isEmpty {
            releaseDate = .empty("TBA")
        }

        var budget = Information.empty("N/A")
        let budgetInt = domain.budget ?? 0
        if let string = currencyFormatter.string(from: NSNumber(value: budgetInt)) {
            budget = budgetInt > .zero ? .content(string) : .empty(string)
        }
        var revenue = Information.empty("N/A")
        let revenueInt = domain.revenue ?? 0
        if let string = currencyFormatter.string(from: NSNumber(value: revenueInt)) {
            revenue = revenueInt > .zero ? .content(string) : .empty(string)
        }
        var runtime = Information.empty("N/A")
        let runtimeInt = domain.runtime ?? 0
        if let string = runtimeFormatter.string(from: TimeInterval(runtimeInt * 60)) {
            runtime = runtimeInt > .zero ? .content(string) : .empty(string)
        }
        self.generalInformation = [
            .init(title: "Release Date", information: releaseDate),
            .init(title: "Duration", information: runtime),
            .init(title: "Budget", information: budget),
            .init(title: "Revenue", information: revenue)
        ]
    }
}
