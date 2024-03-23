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
        movies: [
            .mock(),
            .mock(id: 2, posterPath: "https://image.tmdb.org/t/p/w500/6rwk7nlvq8nj7dwHGprorg57leX.jpg"),
            .mock(id: 3, posterPath: nil), .mock(id: 4, posterPath: nil)
        ]
    ) { _ in }
}
