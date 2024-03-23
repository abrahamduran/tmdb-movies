//
//  MovieCell.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct MovieCell: View {
    let posterPath: String

    var body: some View {
        KFImage(URL(string: posterPath))
            .placeholder {
                ProgressView()
            }
            .cancelOnDisappear(true)
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .cornerRadius(8)
    }
}


#Preview {
    MovieCell(posterPath: Movie.mock().posterPath)
        .padding()
}
