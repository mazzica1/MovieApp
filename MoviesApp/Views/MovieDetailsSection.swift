//
//  MovieDetailsSection.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI

// MARK: - MovieDetailsSection
struct MovieDetailsSection: View {
    let details: MovieDetail
    @State private var myImage: UIImage? = nil
    private func fetchImage() {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(details.posterPath ?? "")")!
        
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
        VStack(alignment: .leading, spacing: 10) {
            // Poster Image
            Group {
                if myImage == nil {
                    ProgressView()
                } else {
                    Image(uiImage: myImage!)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                fetchImage()
            }
            
            // Title and Overview
            Text(details.title!)
                .font(.title)
                .bold()
            Text(details.overview!)
                .font(.body)
                .foregroundColor(.gray)

            // Additional Info
            VStack(alignment: .leading, spacing: 5) {
                Text("Tagline: \(details.tagline ?? "")")
                Text("Revenue: $\(details.revenue)")
                Text("Release Date: \(details.releaseDate?.toString() ?? "")")
                Text("Status: \(details.status ?? "")")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
}

