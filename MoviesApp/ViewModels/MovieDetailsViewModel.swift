//
//  MovieDetailsViewModel.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI
import CoreData
import Combine

// MARK: - MovieDetailsViewModel
class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetail?
    @Published var similarMovies: [Movie] = []
    @Published var topCast: [CastMember] = []
    private let movieService = MovieService()
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchMovieDetails(for movieId: Int64) {
        fetchMovieDetailsFromAPI(movieId: movieId)
        fetchSimilarMovies(movieId: movieId)
        fetchCastForSimilarMovies(movieId: movieId)
    }

    private func fetchMovieDetailsFromAPI(movieId: Int64) {
        movieService.fetchMovieDetails(movieId: movieId) { data , error in
            if error == nil, let data = data  {
                let fetchRequest: NSFetchRequest<MovieDetail> = MovieDetail.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title == %@", data.title)
                var movieDetailsInner: MovieDetail?
                if (try? self.context.fetch(fetchRequest).first) == nil {
                    movieDetailsInner = MovieDetail(context: self.context)
                    movieDetailsInner?.title = data.title
                    movieDetailsInner?.overview = data.overview
                    movieDetailsInner?.posterPath = data.posterPath
                    movieDetailsInner?.releaseDate = data.releaseDate.stringToDate()
                    movieDetailsInner?.tagline = data.tagline
                    movieDetailsInner?.revenue = Int64(data.revenue)
                    movieDetailsInner?.status = data.status
                } else {
                    movieDetailsInner = try? self.context.fetch(fetchRequest).first
                }
                do {
                    try self.context.save()
                    self.movieDetails = movieDetailsInner
                } catch {
                    print("Failed to save similar movies: \(error)")
                }
            }
        }
    }

    private func fetchSimilarMovies(movieId: Int64) {
        movieService.fetchSimilarMovies(movieId: movieId) { data, error in
            if error == nil, let data = data  {
                for apiMovie in data.results {
                    let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d", apiMovie.id)

                    if (try? self.context.fetch(fetchRequest).first) == nil && apiMovie.releaseDate?.isEmpty == false {
                        let movie = Movie(context: self.context)
                        movie.id = Int64(apiMovie.id)
                        movie.title = apiMovie.title
                        movie.overview = apiMovie.overview
                        movie.posterPath = apiMovie.posterPath
                        movie.releaseDate = apiMovie.releaseDate!.stringToDate()
                    }
                }
                do {
                    try self.context.save()
                    self.loadSimilarMovies()
                } catch {
                    print("Failed to save similar movies: \(error)")
                }
            }
        }
    }

    private func loadSimilarMovies() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        fetchRequest.fetchLimit = 5

        do {
            similarMovies = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch similar movies: \(error)")
        }
    }

    private func fetchCastForSimilarMovies(movieId: Int64) {
        movieService.fetchCastForSimilarMovies(movieId: movieId) { data, error in
            if error == nil, let data = data  {
                for apiCast in data.cast + data.crew {
                    let fetchRequest: NSFetchRequest<CastMember> = CastMember.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d", apiCast.id)

                    if (try? self.context.fetch(fetchRequest).first) == nil && apiCast.department != nil {
                        let castMember = CastMember(context: self.context)
                        castMember.id = Int64(apiCast.id)
                        castMember.name = apiCast.name
                        castMember.popularity = apiCast.popularity
                        castMember.department = apiCast.department
                    }
                }
                do {
                    try self.context.save()
                    self.loadTopCast()
                } catch {
                    print("Failed to save cast members: \(error)")
                }
            }
        }
    }

    private func loadTopCast() {
        let fetchRequest: NSFetchRequest<CastMember> = CastMember.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        fetchRequest.fetchLimit = 5

        do {
            topCast = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch top cast members: \(error)")
        }
    }
}
