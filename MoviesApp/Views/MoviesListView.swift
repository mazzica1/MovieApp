//
//  MoviesListView.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI
import CoreData

// MARK: - MoviesListView
struct MoviesListView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: MoviesViewModel
    
    // @State private var searchText = ""
    
    init(vm: MoviesViewModel) {
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                SearchBar(text: $viewModel.searchText)
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.groupedMovies.keys.sorted(by: >), id: \.self) { year in
                            Section(header: Text(year)) {
                                ForEach(viewModel.groupedMovies[year] ?? [], id: \.self) { movie in
                                    NavigationLink(destination: MovieDetailsView(context: context, movieId: movie.id)) {
                                        MovieRow(movie: movie, isInWatchlist: movie.isInWatchlist) {
                                            viewModel.toggleWatchlist(for: movie)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
            }
            .navigationTitle("Movies")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Search movies...", text: $text)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}
