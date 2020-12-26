//
//  ViewController.swift
//  Movies
//
//  Created by Адиль Медеуев on 26.12.2020.
//

import UIKit
import Moya

class ViewController: UITableViewController {
    let cache = NSCache<NSString, NSArray>()
    var movies = [Movie]()
    var images = [UIImage]()
    let movieService = MoyaProvider<MovieService>()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl = refresher
        getCachedMovies()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        movies = [Movie]()
        currentPage = 1
        getMovies(page: currentPage)
        refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == movies.count {
            currentPage += 1
            getMovies(page: currentPage)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(movieTitle: movie.title, releaseDate: movie.releaseDate, average: movie.voteAverage, imageURL: movie.backdropPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.movie = movies[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getCachedMovies() {
        if let cachedMovies = cache.object(forKey: "CachedMovies") {
            self.movies = cachedMovies as! [Movie]
        } else {
            getMovies(page: currentPage)
        }
    }

    func getMovies(page: Int) {
        movieService.request(.popular(page: page)) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try! decoder.decode(MoviesResult.self, from: response.data)
                if let moviesResult = json.results {
                    self.movies.append(contentsOf: moviesResult)
                    self.cache.setObject(self.movies as NSArray, forKey: "CachedMovies")
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
