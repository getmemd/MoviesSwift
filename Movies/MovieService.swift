//
//  MovieService.swift
//  Movies
//
//  Created by Адиль Медеуев on 24.12.2020.
//

import Foundation
import Moya

private let apiKey = "fdd1105035ded7c3879ab303511366ac"

enum MovieService {
    case popular(page: Int)
    case movie(movieID: Int)
}

extension MovieService: TargetType {
    var sampleData: Data {
        return Data()
    }
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .popular(_):
            return "/movie/popular"
        case .movie(let movieID):
            return "/movie/\(movieID)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .movie(_):
            return .requestParameters(parameters: ["api_key": apiKey], encoding: URLEncoding.queryString)
        case .popular(let page):
            return .requestParameters(parameters: ["page": page, "api_key": apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
