//
//  DetailViewController.swift
//  Movies
//
//  Created by Адиль Медеуев on 26.12.2020.
//

import UIKit
import Moya

class DetailViewController: UIViewController {
    @IBOutlet var backdropCard: UIImageView!
    @IBOutlet var average: UILabel!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var overview: UILabel!
    let imageService = MoyaProvider<ImageService>()
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.layer.cornerRadius = 5
        releaseDate.layer.cornerRadius = 5
        average.layer.cornerRadius = 25
        movieTitle.font = UIFont(name: "Manrope", size: 20)
        if let movie = movie {
            title = movie.title
            movieTitle.text = movie.title
            releaseDate.text = movie.releaseDate
            overview.text = movie.overview
            average.text = "\(movie.voteAverage ?? 0.0)"
            getImage(url: movie.backdropPath ?? "")
        }
        backdropCard.layer.cornerRadius = 15
    }
    
    func getImage(url: String) {
        imageService.request(.w500(url: url)) { (result) in
            switch result {
            case .success(let response):
                if let backdropCard = try? response.mapImage() {
                    self.backdropCard.image = backdropCard
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
