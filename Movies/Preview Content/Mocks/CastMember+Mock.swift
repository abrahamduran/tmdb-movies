//
//  CastMember+Mock.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

extension CastMember {
    static func mock(id: Int = 70851, name: String = "Jack Black", character: String = "Po (voice)", profilePath: String? = "/rtCx0fiYxJVhzXXdwZE2XRTfIKE.jpg") -> CastMember {
        .init(id: id, name: name, character: character, profilePath: profilePath)
    }
}
