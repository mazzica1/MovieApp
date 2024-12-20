//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI
import CoreData

// MARK: - MovieDetailsView
struct MovieDetailsView: View {
    @Environment(\.managedObjectContext) private var context: NSManagedObjectContext
    @StateObject private var viewModel: MovieDetailsViewModel
    let movieId: Int64
    init(context: NSManagedObjectContext, movieId: Int64) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(context: context))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let movieDetails = viewModel.movieDetails {
                    // Movie Details Section
                    MovieDetailsSection(details: movieDetails)
                } else {
                    ProgressView("Loading movie details...")
                }

                Divider()

                // Similar Movies Section
                Text("Similar Movies")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.similarMovies) { movie in
                            SimilarMovieRow(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }

                Divider()

                // Top Cast Section
                Text("Top Cast")
                    .font(.headline)
                    .padding(.horizontal)

                ForEach(viewModel.topCast, id: \.id) { cast in
                    CastRow(cast: cast)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchMovieDetails(for: movieId)
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
