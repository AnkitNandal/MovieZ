//
//  MovieListCell.swift
//  Moviez
//
//  Created by Ankit Nandal on 05/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
   
    var cellData: MovieList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(info:MovieList) {
        cellData = info
        titleLabel.text = info.title
        releaseDateLabel.text = info.releaseDate
        descriptionLabel.text = info.overview
        posterImageView.downloadImage(with: info.imagePath)
    }
    
}

extension MovieListCell {
    static let identifier = "movieCell"
    static let xib  = "MovieListCell"
}
