//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Адиль Медеуев on 27.12.2020.
//

import UIKit
import Moya

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var backdropCard: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var averageLabel: UILabel!
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(movieTitle: String?, releaseDate: String?, average: Double?, imageURL: String?) {
        movieTitleLabel.text = movieTitle
        releaseDateLabel.text = releaseDate
        averageLabel.text = "\(average ?? 0.0)"
        setBackgroundImage(url: imageURL ?? "")
        backdropCard.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 8
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func setBackgroundImage(url: String) {
        MoyaProvider<ImageService>().request(.w500(url: url)) { (result) in
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
