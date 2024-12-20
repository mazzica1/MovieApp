//
//  MovieService.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 20/12/2024.
//
import Foundation
class MovieService {
    func fetchMovies(searchText: String = "", completion: @escaping (APIMovieResponse?, Error?) -> Void) {
        let urlString = searchText.isEmpty ? "https://api.themoviedb.org/3/movie/popular" : "https://api.themoviedb.org/3/search/movie?query=\(searchText)"
        executeRequest(urlString: urlString, completion: completion)
    }
    func fetchMovieDetails(movieId: Int64, completion: @escaping (MovieDetailResponse?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)"
        executeRequest(urlString: urlString, completion: completion)
    }
    func fetchSimilarMovies(movieId: Int64, completion: @escaping (APIMovieResponse?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/similar"
        executeRequest(urlString: urlString, completion: completion)
    }
    func fetchCastForSimilarMovies(movieId: Int64, completion: @escaping (APICastResponse?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits"
        executeRequest(urlString: urlString, completion: completion)
    }
    private func executeRequest<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5N2VlYjQwODJkMDhhYTkwYmY1ZTk3ZjU1OGRlYzg5ZSIsIm5iZiI6MTczNDcwMTcyOS43OTUsInN1YiI6IjY3NjU3MmExZjkyNmJlMDNjYzc0YTAzYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.71Ac0toANeEpSQWi23M9tl5qwqs6ZcD4QrIurQuayN8", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: { data, resp, error in
            if let error = error {
                print("Failed to fetch movies: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded, nil)
                }
            } catch {
                print("Failed to decode movies: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }).resume()
    }
}
