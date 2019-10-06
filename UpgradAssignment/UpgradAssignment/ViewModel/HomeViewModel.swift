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
    
    var reloadCollectionView : (() -> Void)? = nil
    
    var pageNo = 0
    var totalPages = 0
    
    
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
    
    func sortMoviesBy(sortType: SortType) {
        var sortedArray = [Movie]()
        switch sortType {
        case .popularity:
            sortedArray = movieItems.sorted { (movie1, movie2) -> Bool in
                return movie1.popularity > movie2.popularity
            }
        case .rating:
            sortedArray = movieItems.sorted { (movie1, movie2) -> Bool in
                return movie1.vote_average > movie2.vote_average
            }
        }
        currentSortType = sortType
        self.movieItems = sortedArray
    }
}

