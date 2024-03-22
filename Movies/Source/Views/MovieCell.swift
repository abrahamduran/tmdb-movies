//
//  MovieCell.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct MovieCell: View {
    private var basePath: String {
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "TMDBPosterPath") as? String else {
            assertionFailure("TMDBPosterPath not found in Info.plist")
            return "https://image.tmdb.org/t/p/w500"
        }
        return basePath
    }
    let posterPath: String

    var body: some View {
        KFImage(URL(string: "\(basePath)\(posterPath)"))
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
