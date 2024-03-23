//
//  BackdropView.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct BackdropView: View {
    let backdropPath: String
    
    var body: some View {
        KFImage(URL(string: backdropPath))
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
