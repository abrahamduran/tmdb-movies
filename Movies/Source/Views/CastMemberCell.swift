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
            profilePic

            VStack(alignment: .leading) {
                Text(castMember.name)
                    .font(.headline)
                Text(castMember.character)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    private var profilePic: some View {
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
    VStack {
        CastMemberCell(castMember: .mock())
        CastMemberCell(castMember: .mock(profilePath: nil))
    }
}
