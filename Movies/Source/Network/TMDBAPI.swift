//
//  TMDBAPI.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import Foundation

protocol APIProvider {
    func fetch(from url: URL, parameters: [URLQueryItem]?) async throws -> Data
}

final class TMDBAPI: APIProvider {
    private var apiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "TMDBApiKey") as? String
    }

    private let session: URLSession
    private let language: String
    private let region: String

    init(session: URLSession = .shared, language: String = Locale.current.identifier(.bcp47), region: String = Locale.current.region?.identifier ?? "US") {
        self.session = session
        self.language = language
        self.region = region
    }

    func fetch(from url: URL, parameters: [URLQueryItem]?) async throws -> Data {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = parameters ?? []
        queryItems.append(URLQueryItem(name: "language", value: language))
        queryItems.append(URLQueryItem(name: "region", value: region))
        if let apiKey {
            queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        }
        components?.queryItems = queryItems

        guard let finalUrl = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: finalUrl)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
