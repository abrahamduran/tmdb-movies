//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Abraham Duran on 3/22/24.
//

import SwiftUI

struct MovieDetailsView: View {
    @StateObject private var viewModel = MovieDetailsViewModel()
    let movie: Movie

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                switch viewModel.content {
                case .loading:
                    loadingView
                case .content(let details):
                    DetailsView(details: details, parentSize: proxy.size)
                case .error:
                    errorView
                }
            }
        }
        .navigationTitle(movie.title)
        .task {
            await viewModel.fetchDetails(for: movie)
        }
        .refreshable {
            await viewModel.refreshDetails(for: movie)
        }
    }

    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .padding()
    }

    private var errorView: some View {
        ErrorView(message: "An error has ocurred\n\(viewModel.error?.recoverySuggestion ?? "Pull to refresh to try again")")
            .padding()
    }

    private struct DetailsView: View {
        private let overviewLayout = [GridItem(.adaptive(minimum: 100), alignment: .leading), GridItem(.flexible(), alignment: .leading)]
        let details: MovieDetailsPresentation
        let parentSize: CGSize

        var body: some View {
            VStack(alignment: .leading) {
                header(backdropWidth: parentSize.width, posterWidth: parentSize.width / 5)

                title

                rating

                overview

                cast

                recommendations
            }
        }
        private let rows = [GridItem(.flexible(maximum: 150))]

        private var title: some View {
            HStack {
                Text(details.title)
                    .font(.title3.bold())

                Text("(\(details.releaseYear))")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }

        private var rating: some View {
            Text(details.rating)
                .padding(.horizontal)
        }

        private var overview: some View {
            VStack(alignment: .leading) {
                Text("Overview")
                    .font(.headline)

                Text(details.overview)
                    .fixedSize(horizontal: false, vertical: true)

                LazyVGrid(columns: overviewLayout, spacing: 8) {
                    VStack(alignment: .leading) {
                        Text("Release Date")
                            .font(.headline)
                        Text(details.releaseDate)
                    }
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .font(.headline)
                        Text(details.runtime)
                    }
                    VStack(alignment: .leading) {
                        Text("Budget")
                            .font(.headline)
                        Text(details.budget)
                    }
                    VStack(alignment: .leading) {
                        Text("Revenue")
                            .font(.headline)
                        Text(details.revenue)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Genres")
                        .font(.headline)
                    Text(details.genres)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding([.top, .horizontal])
        }

        private var cast: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("Cast")
                        .font(.title3.bold())

                    Spacer()

                    if details.cast.isEmpty == false {
                        NavigationLink("View All") {
                            ScrollView {
                                CastGridView(cast: details.cast)
                                    .padding()
                            }
                            .navigationTitle("Cast")
                        }
                    }
                }

                if details.cast.isEmpty {
                    Text("No cast information available at the moment. Please check later.")
                        .foregroundStyle(.secondary)
                } else {
                    CastGridView(cast: Array(details.cast.prefix(3)))
                }
            }
            .padding([.top, .horizontal])
        }

        private var recommendations: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("Recommendations")
                        .font(.title3.bold())

                    Spacer()

                    if details.recommendations.isEmpty == false {
                        NavigationLink("View All") {
                            ScrollView {
                                MoviesGridView(movies: details.recommendations) { _ in }
                                    .padding(.horizontal)
                            }
                            .navigationTitle("Recommendations")
                        }
                    }
                }

                if details.recommendations.isEmpty {
                    Text("No recommendations available at the moment. Please check later.")
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(details.recommendations) { movie in
                                NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                    MovieCell(posterPath: movie.posterPath)
                                        .frame(maxHeight: 250)
                                }
                            }
                        }
                    }
                }
            }
            .padding([.top, .horizontal])
        }

        private func header(backdropWidth: CGFloat, posterWidth: CGFloat) -> some View {
            ZStack(alignment: .bottomLeading) {
                BackdropView(backdropPath: details.backdropPath)
                    .frame(width: backdropWidth)

                MovieCell(posterPath: details.posterPath)
                    .frame(width: posterWidth)
                    .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
//        MovieDetailsView(movie: .init(id: 763215, title: "Damsel", posterPath: ""))
        MovieDetailsView(movie: .init(id: 1011985, title: "Kung Fu Panda 4", posterPath: ""))
    }
}
