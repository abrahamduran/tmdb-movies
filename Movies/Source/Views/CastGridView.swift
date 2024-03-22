//
//  CastGridView.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI

struct CastGridView: View {
    private let columns = [GridItem(.adaptive(minimum: 200), alignment: .leading)]
    let cast: [CastMember]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(cast) { castMember in
                CastMemberCell(castMember: castMember)
            }
        }
    }
}

#Preview {
    CastGridView(cast: [.mock(), .mock(id: 1), .mock(id: 2)])
}
