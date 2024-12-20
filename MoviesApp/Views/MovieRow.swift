//
//  MovieRow.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI

// MARK: - MovieRow
struct MovieRow: View {
    let movie: Movie
    @State var isInWatchlist: Bool
    let onToggleWatchlist: () -> Void
    @State private var myImage: UIImage? = nil
    private func fetchImage() {
        let url = URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath ?? "")")!
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    withAnimation {
                        myImage = image
                    }
                }
            }
        }
    }
    var body: some View {
        HStack {
            // Movie Image
            Group {
                if myImage == nil {
                    ProgressView()
                } else {
                    Image(uiImage: myImage!)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 50, height: 75)
            .cornerRadius(5)

            .onAppear {
                fetchImage()
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title!)
                    .font(.headline)
                Text(movie.overview!)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Watchlist Toggle
            Button(action: {
                isInWatchlist.toggle()
                onToggleWatchlist()
            }) {
                Image(systemName: isInWatchlist ? "bookmark.fill" : "bookmark")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 5)
    }
}
