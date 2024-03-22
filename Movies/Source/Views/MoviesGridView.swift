//
//  MoviesGridView.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI

struct MoviesGridView: View {
    private let columns = [GridItem(.adaptive(minimum: 150))]

    let movies: [Movie]
    let onCellAppearTask: (Movie) async -> Void

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(movies) { movie in
                NavigationLink(destination: MovieDetailsView(movie: movie)) {
                    MovieCell(posterPath: movie.posterPath)
                }
                .task {
                    await onCellAppearTask(movie)
                }
            }
        }
    }
}

#Preview {
    MoviesGridView(
        movies: [.mock(), .mock(id: 1239251, posterPath: "/yRZfiG1QpRkBc7fAmxfcR7Md5EC.jpg")]
    ) { _ in }
}
