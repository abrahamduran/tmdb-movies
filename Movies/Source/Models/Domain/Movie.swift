//
//  Movie.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import Foundation

struct Movie: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let posterPath: String
}
