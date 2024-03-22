//
//  CastMember.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import Foundation

struct CastMember: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
}
