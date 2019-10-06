//
//  HomeDataModel.swift
//  UpgradAssignment
//
//  Created by AiTechnology on 10/5/19.
//  Copyright © 2019 vinit.somani. All rights reserved.
//

import Foundation

struct HomeDataModel: Codable {
    var results         : [Movie]?
    var page            : Int?
    var total_results   : Int?
    var total_pages     : Int?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case page = "page"
        case total_results = "total_results"
        case total_pages = "total_pages"
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        results = try values.decodeIfPresent([Movie].self, forKey: .results)
    }
}


struct Movie: Codable {

    var id                  : Int?
    var title               : String?
    var popularity          : Double?
    var vote_average        : Double?
    var poster_path         : String?
    var overview            : String?
    var release_date        : String?
    var original_title      : String?
    
    enum CodingKeys: String, CodingKey {
         case id                  = "id"
         case title               = "title"
         case popularity          = "popularity"
         case vote_average        = "vote_average"
         case poster_path         = "poster_path"
         case overview            = "overview"
         case release_date        = "release_date"
         case original_title      = "original_title"
    }
    

    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            title = try values.decodeIfPresent(String.self, forKey: .title)
            popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
            vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
            poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
            overview = try values.decodeIfPresent(String.self, forKey: .overview)
            release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
            original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
        } catch {
            print(error)
        }
    }
}
