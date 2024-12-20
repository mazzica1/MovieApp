//
//  MovieDetailResponse.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

struct MovieDetailResponse: Decodable {
    let title: String
    let overview: String
    let posterPath: String?
    let tagline: String
    let revenue: Int
    let releaseDate: String
    let status: String
    // add coding key for releaseDate as release_date
    enum CodingKeys: String, CodingKey {
        case title, overview, posterPath = "poster_path", tagline, revenue, releaseDate = "release_date", status
    }
}
