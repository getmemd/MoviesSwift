//
//  MovieService.swift
//  Movies
//
//  Created by Адиль Медеуев on 25.12.2020.
//

import Foundation
import Moya

enum ImageService {
    case w500(url: String)
}

extension ImageService: TargetType {
    var sampleData: Data {
        return Data()
    }
    
    var baseURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/")!
    }
    
    var path: String {
        switch self {
        case .w500(let url):
            return "w500\(url)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .w500(_):
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
