//
//  MovieCell.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct MovieCell: View {
    let posterPath: String?

    var body: some View {
        image
            .cornerRadius(8)
    }

    @ViewBuilder
    private var image: some View {
        if let posterPath {
            KFImage(URL(string: posterPath))
                .placeholder {
                    ProgressView()
                }
                .cancelOnDisappear(true)
                .fade(duration: 0.25)
                .resizable()
                .scaledToFit()
        } else {
            Color.secondary
                .opacity(0.2)
                .aspectRatio(0.667, contentMode: .fit)
                .overlay {
                    Image(systemName: "popcorn")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 128)
                        .padding(.horizontal)
                        .foregroundStyle(.secondary)
                }
        }
    }
}


#Preview {
    HStack {
        MovieCell(posterPath: "https://image.tmdb.org/t/p/w500/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg")
            .padding()
        MovieCell(posterPath: nil)
            .padding()
    }
}
