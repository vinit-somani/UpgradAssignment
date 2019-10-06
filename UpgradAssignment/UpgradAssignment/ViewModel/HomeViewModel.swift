//
//  HomeViewModel.swift
//  UpgradAssignment
//
//  Created by AiTechnology on 10/5/19.
//  Copyright © 2019 vinit.somani. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: NSObjectProtocol {
    func didFetchData()
    func fetchingFailed(_ shouldRetry: Bool, message: String)
    func noNetworkConditionHandling()
}

class HomeViewModel {
    var currentSortType: SortType?
    var movieItems: [Movie] = []
    {
        didSet {
            if let reload = self.reloadCollectionView {
                reload()
            }
        }
    }
    
    var searchItems: [Movie] = []
    {
        didSet {
            if let reload = self.reloadCollectionViewForSearch {
                reload()
            }
        }
    }
    
    var reloadCollectionView : (() -> Void)? = nil
    var reloadCollectionViewForSearch : (() -> Void)? = nil
    
    var pageNo = 0
    var totalPages = 0
    
    
    //calling api for most popular moview data and responding to closure accordingly
    func callMostPopularMoviesData() {
        if totalPages >= pageNo
        {
            pageNo += 1
            
            var service = Service.init(httpMethod: WebserviceHTTPMethod.get)
            service.url = API_BASE_URL + popularMoviePath
            service.params = ["api_key":apiKey,
                              "language":"en-US",
                              "page":"\(pageNo)"]
            
            ServiceManager.processDataFromServer(service: service, model: HomeDataModel.self) { [weak self] (response, error) in
                
                guard let self = self else {
                    return
                }
                
                if(error != nil)
                {
                    self.pageNo -= 1
                    print(error.debugDescription)
                    return
                }
                
                if let res = response {
                    self.totalPages = res.total_pages ?? 1
                    if let movies = res.results {
                        self.movieItems.append(contentsOf: movies)
                    }
                } else {
                    self.pageNo -= 1
                }
            }
        }
    }
    
    //performing desired sorting on moview array
    func sortMoviesBy(sortType: SortType) {
        let unsortedArray = self.searchItems.count > 0 ? self.searchItems : self.movieItems
        var sortedArray = [Movie]()
        switch sortType {
        case .popularity:
            sortedArray = unsortedArray.sorted { (movie1, movie2) -> Bool in
                return movie1.popularity > movie2.popularity
            }
        case .rating:
            sortedArray = unsortedArray.sorted { (movie1, movie2) -> Bool in
                return movie1.vote_average > movie2.vote_average
            }
        }
        currentSortType = sortType
        if self.searchItems.count > 0 {
            self.searchItems = sortedArray
        }
        else {
            self.movieItems = sortedArray
        }
    }
    
    
    func filterMoviesBy(text: String) {
        let filteredArray = movieItems.filter { (movie) -> Bool in
            //if let title =
            movie.original_title?.lowercased().removingWhitespaces().contains(text.lowercased().removingWhitespaces()) ?? false
        }
        self.searchItems = filteredArray
    }
    
}


