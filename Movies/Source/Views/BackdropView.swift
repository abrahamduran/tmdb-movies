//
//  BackdropView.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct BackdropView: View {
    private var basePath: String {
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "TMDBBackdropPath") as? String else {
            assertionFailure("TMDBBackdropPath not found in Info.plist")
            return "https://image.tmdb.org/t/p/w1280"
        }
        return basePath
    }
    let backdropPath: String
    
    var body: some View {
        KFImage(URL(string: "\(basePath)\(backdropPath)"))
            .placeholder {
                ProgressView()
            }
            .fade(duration: 0.25)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    BackdropView(backdropPath: "/deLWkOLZmBNkm8p16igfapQyqeq.jpg")
}
