//
//  ProfileCell.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI
import Kingfisher

struct CastMemberCell: View {
    let castMember: CastMember

    var body: some View {
        HStack {
            if let profilePath = castMember.profilePath {
                KFImage(URL(string: profilePath))
                    .placeholder {
                        placeholder
                    }
                    .cancelOnDisappear(true)
                    .fade(duration: 0.5)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            } else {
                placeholder
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

    private var placeholder: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .foregroundStyle(.secondary)
            .frame(width: 64, height: 64)
            .clipShape(Circle())
    }
}

#Preview {
    CastMemberCell(castMember: .mock())
}
