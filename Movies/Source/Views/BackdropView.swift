//
//  BackdropView.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct BackdropView: View {
    let backdropPath: String?
    
    var body: some View {
        if let backdropPath {
            KFImage(URL(string: backdropPath))
                .placeholder {
                    ProgressView()
                }
                .fade(duration: 0.25)
                .resizable()
                .scaledToFill()
        } else {
            Color.secondary
                .opacity(0.2)
                .aspectRatio(1.778, contentMode: .fill)
                .overlay {
                    Image(systemName: "movieclapper")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 128)
                        .foregroundStyle(.secondary)
                }
        }
    }
}

#Preview {
    VStack {
        BackdropView(backdropPath: "https://image.tmdb.org/t/p/w1280/deLWkOLZmBNkm8p16igfapQyqeq.jpg")
        BackdropView(backdropPath: nil)
    }
}
