//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI
import CoreData
import Combine

// MARK: - MoviesViewModel
class MoviesViewModel: ObservableObject {
    @Published var groupedMovies: [String: [Movie]] = [:]
    @Published var searchText: String = "" {
        didSet {
            fetchMovies()
        }
    }
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let context: NSManagedObjectContext
    private let movieService = MovieService()
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchMovies()
    }
    
    func fetchMovies() {
        isLoading = true
        movieService.fetchMovies(searchText: searchText) { data, error in
            if error == nil, let data = data  {
                self.saveMovies(from: data.results)
            }
            self.isLoading = false
            self.groupMoviesByYear()
        }
    }

    private func saveMovies(from apiMovies: [APIMovie]) {
        for apiMovie in apiMovies {
            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", apiMovie.id)

            if (try? context.fetch(fetchRequest).first) == nil && apiMovie.releaseDate != nil{
                let movie = Movie(context: context)
                movie.id = Int64(apiMovie.id)
                movie.title = apiMovie.title
                movie.overview = apiMovie.overview
                movie.posterPath = apiMovie.posterPath
                
                movie.releaseDate = apiMovie.releaseDate!.stringToDate()
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed to save movies: \(error)")
        }
    }

    private func groupMoviesByYear() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            if !searchText.isEmpty {
                fetchRequest.predicate = NSPredicate(format: "title like %@", "*\(searchText)*")
            }
            let movies = try context.fetch(fetchRequest)
            groupedMovies = Dictionary(grouping: movies) { movie in
                String(movie.releaseDate?.toString().prefix(4) ?? "Unknown")
            }
        } catch {
            print("Failed to fetch movies from Core Data: \(error)")
        }
    }

    func toggleWatchlist(for movie: Movie) {
        movie.isInWatchlist.toggle()
        do {
            try context.save()
        } catch {
            print("Failed to update watchlist: \(error)")
        }
    }
}

extension String {

    func stringToDate(withFormat format: String = "yyyy-MM-dd")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}
extension Date {

    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
