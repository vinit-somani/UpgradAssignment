//
//  MovieDetailViewController.swift
//  UpgradAssignment
//
//  Created by AiTechnology on 10/6/19.
//  Copyright © 2019 vinit.somani. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var textView: UITextView!
    var movieModel: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMovieModelValuesOnVC()
    }
    
    func setupMovieModelValuesOnVC() {
        self.title = movieModel.original_title
        if movieModel.vote_average > 0 {
            self.movieRating.text = "\(movieModel.vote_average)"
        }
        else {
            self.movieRating.text = "Not mentioned"
        }

        let releaseDate = movieModel.release_date ?? "Not mentioned."
        self.movieReleaseDate.text = releaseDate

        var description = "No description available."
        if let overview = movieModel.overview, overview.count > 0 {
            description = overview
        }
        self.textView.text = description
        
        guard let subUrl = movieModel.poster_path else {
            return
        }
        
        if let url = URL.init(string: IMAGE_BASE_URL + subUrl) {
            imageView.sd_setImage(with: url) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            }
        }
    }
    
}
