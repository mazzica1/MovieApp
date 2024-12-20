//
//  APIMovie.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

struct APIMovie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    enum CodingKeys: String, CodingKey {
        case id, title, overview, posterPath = "poster_path", releaseDate = "release_date"
    }
}
