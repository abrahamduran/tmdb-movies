//
//  MoviesPageResponse.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import Foundation

struct MoviesPageResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}
