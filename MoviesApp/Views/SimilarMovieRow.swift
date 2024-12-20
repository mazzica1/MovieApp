//
//  SimilarMovieRow.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI

// MARK: - SimilarMovieRow
struct SimilarMovieRow: View {
    let movie: Movie
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
        VStack {
            Group {
                if myImage == nil {
                    ProgressView()
                } else {
                    Image(uiImage: myImage!)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 100, height: 150)
            .cornerRadius(8)

            .onAppear {
                fetchImage()
            }
            
            Text(movie.title!)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
