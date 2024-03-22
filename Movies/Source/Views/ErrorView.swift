//
//  ErrorView.swift
//  Movies
//
//  Created by Abraham Duran on 3/21/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.gray)
                .font(.largeTitle)
                .frame(maxWidth: .infinity)

            Text(message)
                .font(.headline.bold())
                .foregroundStyle(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .accessibilityIdentifier("ErrorView")
    }
}

#Preview {
    ErrorView(message: "An error has ocurred")
}
