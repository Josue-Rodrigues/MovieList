//
//  ListarFilmeResponse.swift
//  Movie List
//
//  Created by Josue Herrera Rodrigues on 10/11/21.
//

import UIKit


struct MovieListResponse: Codable {
    
    let results: [MovieList]
}

struct MovieList: Codable {
    
    let title: String
    let release_date: String
    let poster_path: String
    let id: Int64

}
