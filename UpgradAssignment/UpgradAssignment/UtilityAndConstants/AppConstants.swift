//
//  AppConstants.swift
//  UpgradAssignment
//
//  Created by AiTechnology on 10/5/19.
//  Copyright © 2019 vinit.somani. All rights reserved.
//

import UIKit


public enum ParameterEncoding {
    case JSON
    case URL
    case BODY
}

public enum SortType: String {
    case popularity
    case rating
    
    var name: String {
        switch self {
        case .popularity:
            return "Most Popular"
        case .rating:
            return "Top Rated"
        }
    }
}

let screenHeight:CGFloat = UIScreen.main.bounds.height
let screenWidth:CGFloat = UIScreen.main.bounds.width
let moviewCellWidth = (screenWidth - 20 - 16) / 2
let movieCellHeight = moviewCellWidth*3/2
let networkErrorMessage = "Please check your device's network and retry!"
let MovieCellIdentifier = "MovieCollectionViewCell"
let apiKey = "1d4bf29685aafb1436afc4e9ea61b5a3"


//MARK:- Base Path urls
let API_BASE_URL    = "https://api.themoviedb.org/3/"
let IMAGE_BASE_URL      = "https://image.tmdb.org/t/p/w500/"

let popularMoviePath = "movie/popular"

//Completion Blocks
typealias RequestCompletionBlock = (Data?, URLResponse?, Error?) -> ()
typealias APISuccessBlock = (_ isSuccess: Bool, _ errorMsg: String?) -> ()
