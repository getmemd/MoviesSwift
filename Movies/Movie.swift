//
//  Movie.swift
//  Movies
//
//  Created by Адиль Медеуев on 26.12.2020.
//

import Foundation

class Movie: Decodable {
    let overview: String?
    let backdropPath: String?
    let releaseDate: String?
    let id: Int
    let title: String?
    let voteAverage: Double?
}

class MoviesResult: Decodable {
    let page: Int
    let results: [Movie]?
}
