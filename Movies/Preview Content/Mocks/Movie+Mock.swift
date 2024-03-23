//
//  Movie+Mock.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

extension Movie {
    static func mock(id: Int = 1011985, title: String = "Kung Fu Panda 4", posterPath: String? = "https://image.tmdb.org/t/p/w500/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg") -> Movie {
        .init(id: id, title: title, posterPath: posterPath)
    }
}
