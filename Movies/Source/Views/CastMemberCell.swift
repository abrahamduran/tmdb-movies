//
//  ProfileCell.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct CastMemberCell: View {
    private var basePath: String {
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "TMDBProfilePath") as? String else {
            assertionFailure("TMDBProfilePath not found in Info.plist")
            return "https://image.tmdb.org/t/p/h632"
        }
        return basePath
    }
    let castMember: CastMember

    var body: some View {
        HStack {
            if let profilePath = castMember.profilePath, let url = URL(string: "\(basePath)\(profilePath)") {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                    }
                    .cancelOnDisappear(true)
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading) {
                Text(castMember.name)
                    .font(.headline)
                Text(castMember.character)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    CastMemberCell(castMember: .mock())
}
