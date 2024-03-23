//
//  PopularMoviesView.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import SwiftUI

struct PopularMoviesView: View {
    @StateObject private var viewModel = PopularMoviesViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            switch viewModel.content {
            case .loading:
                loadingView
            case .content(let movies):
                MoviesGridView(movies: movies) { movie in
                    await viewModel.onItemAppear(movie)
                }
                .padding(.horizontal)
                if viewModel.isLoadingPage {
                    loadingView
                }
            case .error:
                errorView
            }
        }
        .accessibilityIdentifier("PopularMoviesView")
        .navigationTitle("Popular Movies")
        .alert(isPresented: $viewModel.showErrorAlert, error: viewModel.error, actions: { _ in
            Button("OK") { }
        }, message: { error in
            Text(error.recoverySuggestion ?? "Try again later.")
        })
        .task {
            await viewModel.fetchContent()
        }
        .refreshable {
            await viewModel.refreshContent()
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
}

#Preview {
    NavigationStack {
        PopularMoviesView()
    }
}
